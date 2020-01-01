# frozen_string_literal: true

module YoutubeParser
  module Search
    class Channels < BaseParser
      DEFAULT_PARAMS = { sp: 'EgIQAg%3D%3D' }.freeze

      options :search_query

      def info
        (channels(search)[:channels] || []).map { |c| channel_info c }
      end

      def for_each_channel
        for_each_page do |channels|
          channels.each { |channel| yield channel_info channel }
        end
      end

      private

      def for_each_page
        channels = channels(search)
        return if channels.empty? || channels[:channels].empty?

        loop do
          yield channels[:channels]

          break unless channels[:continuation]

          channels = channels(search(ctoken: channels[:continuation]))

          break if channels.empty?
        end
      end

      def search(opts = {})
        opts = opts.merge(params)
        client.get('results', opts)
      end

      def channels(json)
        page_contents = json.dig(*keys.channels_page)
        continuation_contents = json.dig(*keys.continuation_contents)
        return {} if page_contents.nil? && continuation_contents.nil?

        contents = (page_contents || [continuation_contents&.dig('contents')])
        contents.each do |content|
          channels = scrape_channels content
          channels_hash = {
            channels: channels,
            continuation: continuation(continuation_contents, content)
          }

          return channels_hash if channels.any?
        end

        {}
      end

      def continuation(contents, content)
        continuations = content.dig(*keys.renderer_continuations)
        continuations = contents&.dig(*keys.continuations) if contents
        continuations&.map do |cont|
          cont.dig(*keys.continuation)
        end&.compact&.first
      end

      def scrape_channels(content)
        contents = content
        contents = content.dig(*keys.channels_contents) if content.is_a? Hash
        contents&.map { |c| c.dig(*keys.channel_renderer) }&.compact || []
      end

      def channel_info(channel)
        channel_url = channel.dig(*keys.channel_url)
        opts = { channel_url: channel_url, client: client }

        YoutubeParser::Channel.new(opts).info
      end

      def params
        options.attributes.slice(*required_options).merge(DEFAULT_PARAMS)
      end
    end
  end
end
