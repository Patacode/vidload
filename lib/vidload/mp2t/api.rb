# frozen_string_literal: true

require 'playwright'
require 'tty-spinner'
require 'open3'
require 'm3u8'
require 'io/console'
require 'fileutils'
require 'lucky_case'

module Vidload
  module Mp2t
    module Api
      DEMUXER_PATH = "#{__dir__}/remuxer.sh".freeze
      VIDEO_DOWNLOADED_EVENT_QUEUE = Queue.new
      VIDEO_START_DOWNLOAD_EVENT_QUEUE = Queue.new
      VIDEO_INDEX_EVENT_QUEUE = Queue.new
      ANSI_BOLD_WHITE = "\033[1;97m"
      ANSI_LIGHT_GREY = "\033[37m"
      ANSI_RESET = "\033[0m"

      class DownloaderBuilder
        REQUIRED_ARGS = %i[video_url hls_url master_playlist_name playwright_cli_path video_referer
                           ts_seg_pattern hls_index_pattern].freeze

        def initialize
          @kwargs = {}
        end

        def with_kwargs(**kwargs)
          @kwargs = kwargs
          self
        end

        def with_video_url(video_url)
          @kwargs[:video_url] = video_url
          self
        end

        def with_video_name(video_name)
          @kwargs[:video_name] = video_name
          self
        end

        def with_author_name(author_name)
          @kwargs[:author_name] = author_name
          self
        end

        def with_output_dir(output_dir)
          @kwargs[:output_dir] = output_dir
          self
        end

        def is_headless?(headless)
          @kwargs[:headless] = headless
          self
        end

        def author_dir?(author_dir)
          @kwargs[:author_dir] = author_dir
          self
        end

        def with_hls_url(hls_url)
          @kwargs[:hls_url] = hls_url
          self
        end

        def with_master_playlist_name(master_playlist_name)
          @kwargs[:master_playlist_name] = master_playlist_name
          self
        end

        def with_playwright_cli_path(playwright_cli_path)
          @kwargs[:playwright_cli_path] = playwright_cli_path
          self
        end

        def with_video_referer(video_referer)
          @kwargs[:video_referer] = video_referer
          self
        end

        def with_ts_seg_pattern(ts_seg_pattern)
          @kwargs[:ts_seg_pattern] = ts_seg_pattern
          self
        end

        def with_hls_index_pattern(hls_index_pattern)
          @kwargs[:hls_index_pattern] = hls_index_pattern
          self
        end

        def build
          REQUIRED_ARGS.each do |required_arg|
            raise ArgumentError, "#{required_arg} must be provided" unless @kwargs[required_arg]
          end

          @kwargs[:video_name] = "#{@kwargs[:author_name]}_#{@kwargs[:video_name]}" if @kwargs[:author_name]

          Downloader.new(**@kwargs)
        end
      end

      class Downloader
        def initialize(**kwargs)
          @max_lines = IO.console.winsize[0]
          @kwargs = kwargs
        end

        def self.builder
          DownloaderBuilder.new
        end

        def self.from_hash(hash)
          builder.with_kwargs(**hash).build
        end

        # main func to be called in your own scripts defined under web/
        def download_video(video_starter_callbacks: [])
          Playwright.create(playwright_cli_executable_path: @kwargs[:playwright_cli_path]) do |playwright|
            browser = playwright.chromium.launch(headless: @kwargs[:headless])
            page = browser.new_page

            manage_video_download(page, *video_starter_callbacks)

            if wait_until_video_start_downloading(timeout: 10).nil?
              puts 'Not possible to download video. Restarting new session'
              browser.close
              download_video(video_starter_callbacks: video_starter_callbacks)
            else
              wait_until_video_downloaded
              browser.close
            end
          end
        end

        def display_calling_args
          puts 'Constants:'
          puts "\tDEMUXER_PATH=#{DEMUXER_PATH}"
          puts 'Called with:'
          @kwargs.each do |key, value|
            puts "\t#{key}=#{value}"
          end
        end

        def self.display_with_spinner(loading_msg = 'Loading...')
          spinner = TTY::Spinner.new("[:spinner] #{loading_msg}")
          spinner.auto_spin
          yield
          spinner.success('(done)')
        end

        private

        def manage_video_download(page, *video_starter_callbacks)
          @seg_qty = nil
          @pending_hls_response = nil
          @lines = [''] * @max_lines
          page.on('response', ->(resp) { listen_to_video_starts(resp) })
          navigate_to_url(@kwargs[:video_url], page)
          video_starter_callbacks.each do |callback|
            res = callback.call(page)
            if !@kwargs[:video_name] && res[:video_name]
              @kwargs[:video_name] = res[:video_name]
              @kwargs[:video_name] = LuckyCase.dash_case(@kwargs[:video_name].gsub(/[^[:alnum:] ]/, ''))
            end
            next unless !@kwargs[:author_name] && res[:author_name]

            @kwargs[:author_name] = res[:author_name]
            @kwargs[:author_name] = LuckyCase.dash_case(@kwargs[:author_name].gsub(/[^[:alnum:] ]/, ''))
            @kwargs[:video_name] = "#{@kwargs[:author_name]}_#{@kwargs[:video_name]}"
          end
        end

        def wait_until_video_downloaded
          VIDEO_DOWNLOADED_EVENT_QUEUE.pop
        end

        def wait_until_video_start_downloading(timeout:)
          VIDEO_START_DOWNLOAD_EVENT_QUEUE.pop(timeout: timeout)
        end

        def trigger_video_download(video_url, seg_qty)
          VIDEO_START_DOWNLOAD_EVENT_QUEUE << true
          puts 'Video starts. Starting download...'
          video_parent_dirs = if @kwargs[:author_dir]
                                if @kwargs[:output_dir]
                                  "#{@kwargs[:output_dir]}/#{@kwargs[:author_name]}"
                                else
                                  @kwargs[:author_name]
                                end
                              else
                                @kwargs[:output_dir]
                              end

          puts video_parent_dirs
          FileUtils.mkdir_p(video_parent_dirs, mode: 0o755)
          run_cmd(DEMUXER_PATH, video_url, "#{video_parent_dirs}/#{@kwargs[:video_name]}",
                  @kwargs[:video_referer]) do |line|
            if (line.include?('hls @') || line.include?('https @')) && line.match?(/#{@kwargs[:ts_seg_pattern]}/i)
              seg_nb = line.match(/#{@kwargs[:ts_seg_pattern]}/i)[:seg_nb]
              add_line(line)
              progress_bar(seg_nb, seg_qty)
            end
          end
          print "\r\e[2K"
          puts "✔ Video downloaded successfully! Available in #{video_parent_dirs}/#{@kwargs[:video_name]}.mp4"
          VIDEO_DOWNLOADED_EVENT_QUEUE << true
        end

        def listen_to_video_starts(response)
          if response.url.start_with?(@kwargs[:hls_url]) && response.url.match?(/#{@kwargs[:hls_index_pattern]}/i)
            body = response.text
            playlist = M3u8::Playlist.read(body)
            last_item = playlist.items.last.segment
            match = last_item.match(/#{@kwargs[:ts_seg_pattern]}/i)
            @seg_qty = match[:seg_nb].to_i

            trigger_video_download(@pending_hls_response.url, @seg_qty) if @pending_hls_response
          elsif response.url.start_with?(@kwargs[:hls_url]) && response.url.include?(@kwargs[:master_playlist_name])
            if @seg_qty
              trigger_video_download(response.url, @seg_qty)
            else
              @pending_hls_response = response
            end
          end
        end

        def navigate_to_url(url, page)
          Downloader.display_with_spinner("Page #{url} loading...") do
            page.goto(url)
          end
        end

        def run_cmd(*cmd, &block)
          Open3.popen2e(*cmd) do |_stdin, stdout_and_stderr, _wait_thr|
            stdout_and_stderr.each_line(&block)
          end
        end

        def redraw_lines
          return if @lines.empty?

          printf "\e[H"
          printf "\e[0J"

          _rows, cols = IO.console.winsize
          @lines.each do |line|
            line.length > cols ? (puts "#{line.slice(0, cols - 3)}...") : (puts line)
          end
        end

        def add_line(line)
          @lines << line
          @lines.shift if @lines.size > @max_lines
          redraw_lines
        end

        def progress_bar(current, total, width: 40)
          ratio = current.to_f / total
          filled = (ratio * width).round
          empty = width - filled

          bar = '█' * filled + '░' * empty
          percent = (ratio * 100).round(1)

          print "\r[#{bar}] #{percent}% (#{current}/#{total})"
        end
      end
    end
  end
end
