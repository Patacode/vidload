# frozen_string_literal: true

require 'thor'

module Vidload
  module Mp2t
    class Cli < Thor
      desc 'mp2t VIDEO_URLS...', 'download one ore more mp2t containerized videos'
      method_option :video_name, type: :string, required: false
      method_option :author_name, type: :string, required: false
      method_option :output_dir, type: :string, required: false
      method_option :headless, type: :boolean, default: true
      method_option :author_dir, type: :boolean, default: false
      method_option :hls_url, type: :string, required: true
      method_option :master_playlist_name, type: :string, required: true
      method_option :playwright_cli_path, type: :string, required: true
      method_option :video_referer, type: :string, required: true
      method_option :ts_seg_pattern, type: :string, required: true
      method_option :hls_index_pattern, type: :string, required: true
      def mp2t(*video_urls)
        video_urls.each do |video_url|
          params = {
            video_url: video_url,
            **options
          }

          process_mp2t(params)
          sleep 1
        end
      end
    end
  end
end
