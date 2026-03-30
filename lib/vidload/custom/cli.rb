# frozen_string_literal: true

require 'thor'

module Vidload
  module Custom
    class Cli < Thor
      desc 'custom VIDEO_URLS...', 'download one ore more mp4 videos'
      method_option :title, type: :string, required: false
      method_option :author_name, type: :string, required: false
      method_option :playwright_cli_path, type: :string, required: true
      method_option :headless, type: :boolean, default: true
      method_option :service_url, type: :string, required: true
      def custom(*video_urls)
        video_urls.each do |video_url|
          params = {
            video_url: video_url,
            **options
          }

          process_custom(params)
          sleep 1
        end
      end

      private

      def process_custom(params)
        raise NotImplementedError
      end
    end
  end
end
