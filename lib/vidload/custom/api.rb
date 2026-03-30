# frozen_string_literal: true

require 'playwright'
require 'tty-spinner'
require 'open3'
require 'io/console'

module Vidload
  module Custom
    module Api
      class DownloaderBuilder
        REQUIRED_ARGS = %i[playwright_cli_path].freeze

        def initialize
          @kwargs = {}
        end

        def with_kwargs(**kwargs)
          @kwargs = kwargs
          self
        end

        def with_service_url(service_url)
          @kwargs[:service_url] = service_url
          self
        end

        def with_video_url(video_url)
          @kwargs[:video_url] = video_url
          self
        end

        def with_title(title)
          @kwargs[:title] = title
          self
        end

        def with_author_name(author_name)
          @kwargs[:author_name] = author_name
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
        def download_video(video_starter_callbacks: [])
          Playwright.create(playwright_cli_executable_path: @kwargs[:playwright_cli_path]) do |playwright|
            browser = playwright.chromium.launch(headless: @kwargs['headless'])
            page = browser.new_page

            manage_video_download(page, *video_starter_callbacks)

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

        def manage_video_download(page, *video_starter_callbacks)
          video_starter_callbacks.each do |callback|
            res = callback.call(page, @kwargs)
            @kwargs[:title] = res[:title] if !@kwargs[:title] && res[:title]
            @kwargs[:author_name] = res[:author_name] if !@kwargs[:author_name] && res[:author_name]
            @kwargs[:cover_img_url] = res[:cover_img_url] if !@kwargs[:cover_img_url] && res[:cover_img_url]
          end
        end
      end
    end
  end
end
