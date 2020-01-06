# frozen_string_literal: true

module YoutubeParser
  module Channels
    class ChannelsSection < BaseParser
      options :channel_url

      def info
        @info ||= channel_urls.map do |url|
          channel_url = "#{client.class::BASE_URL}#{url}"
          opts = { channel_url: channel_url, client: client }

          YoutubeParser::Channel.new(opts).info
        end
      end

      private

      def channel_urls
        channels.map { |c| c.dig(*keys.channels_section_urls) }.compact
      end

      def channels
        tabs = json.dig(*keys.section_tabs) || []
        tabs.map { |t| t.dig(*keys.channels_section) }.compact.first || []
      end

      def json
        @json ||= client.get("#{options.channel_url}/channels")
      end
    end
  end
end
