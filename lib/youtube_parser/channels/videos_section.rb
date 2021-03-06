# frozen_string_literal: true

module YoutubeParser
  module Channels
    class VideosSection < BaseParser
      options :channel_url

      def info
        {
          video_ids: video_ids,
          playlist_id: playlist_id
        }
      end

      private

      def video_ids
        return @video_ids if @video_ids&.any?

        sections.each do |section|
          videos = section.dig(*keys.video_section_tabs) ||
            section.dig(*keys.second_video_section)
          next unless videos.is_a? Array

          @video_ids = scrape_video_ids videos

          return @video_ids if @video_ids.any?
        end

        []
      end

      def playlist_id
        return @playlist_id if @playlist_id

        section = sections.detect { |s| s.dig(*keys.playlist_id) }
        @playlist_id = section&.dig(*keys.playlist_id)
      end

      def scrape_video_ids(videos)
        videos.map { |video| video.dig(*keys.video_ids) }.compact
      end

      def sections
        @sections ||= json.dig(*keys.section_tabs) || []
      end

      def json
        @json ||= client.get("#{options.channel_url}/videos")
      end
    end
  end
end
