# frozen_string_literal: true

require 'playwright'
require 'tty-spinner'
require 'open3'
require 'io/console'

module Vidload
  module Mp4
    module Api
      VIDEO_DOWNLOADED_EVENT_QUEUE = Queue.new

      class DownloaderBuilder
        REQUIRED_ARGS = %i[video_url video_hub_url playwright_cli_path].freeze

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

        def with_video_hub_url(video_hub_url)
          @kwargs[:video_hub_url] = video_hub_url
          self
        end

        def with_playwright_cli_path(playwright_cli_path)
          @kwargs[:playwright_cli_path] = playwright_cli_path
          self
        end

        def is_headless?(headless)
          @kwargs[:headless] = headless
          self
        end

        def build
          REQUIRED_ARGS.each do |required_arg|
            raise ArgumentError, "#{required_arg} must be provided" unless @kwargs[required_arg]
          end

          @kwargs[:video_name] = @kwargs[:video_url].split('/').last unless @kwargs[:video_name]

          Downloader.new(**@kwargs)
        end
      end

      class Downloader
        def initialize(**kwargs)
          @kwargs = kwargs
        end

        def self.builder
          DownloaderBuilder.new
        end

        def self.from_hash(hash)
          builder.with_kwargs(**hash).build
        end

        # main func to be called in your own scripts defined under web/
        def download_video
          Playwright.create(playwright_cli_executable_path: @kwargs[:playwright_cli_path]) do |playwright|
            browser = playwright.chromium.launch(headless: @kwargs[:headless])
            page = browser.new_page

            manage_video_download(page)
            wait_until_video_downloaded

            browser.close
          end
        end

        def display_calling_args
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

        def manage_video_download(page)
          page.on('response', ->(resp) { listen_to_video_starts(page, resp) })
          navigate_to_url(@kwargs[:video_url], page)
        end

        def wait_until_video_downloaded
          Downloader.display_with_spinner('Downloading mp4 video...') do
            VIDEO_DOWNLOADED_EVENT_QUEUE.pop
          end
        end

        def listen_to_video_starts(_page, response)
          content_type = response.headers['content-type']
          return unless response.url.start_with?(@kwargs[:video_hub_url]) && content_type&.include?('video/mp4')

          body = response.text
          File.open("video-#{@kwargs[:video_name]}.mp4", 'wb') do |f|
            f.write(body)
          end
          VIDEO_DOWNLOADED_EVENT_QUEUE << true
        end

        def navigate_to_url(url, page)
          Downloader.display_with_spinner("Page #{url} loading...") do
            page.goto(url)
          end
        end
      end
    end
  end
end
