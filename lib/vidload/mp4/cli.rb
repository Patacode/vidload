# frozen_string_literal: true

require 'thor'

module Vidload
  module Mp4
    class Cli < Thor
      desc 'mp4 VIDEO_URLS...', 'download one ore more mp4 videos'
      method_option :video_name, type: :string, required: false
      method_option :video_hub_url, type: :string, required: true
      method_option :playwright_cli_path, type: :string, required: true
      method_option :headless, type: :boolean, default: true
      def mp4(*video_urls)
        video_urls.each do |video_url|
          params = {
            video_url: video_url,
            **options
          }

          process_mp4(params)
          sleep 1
        end
      end

      private

      def process_mp4(params)
        raise NotImplementedError
      end
    end
  end
end
