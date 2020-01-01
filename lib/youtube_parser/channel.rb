# frozen_string_literal: true

module YoutubeParser
  class Channel < BaseParser
    options :channel_url

    def info
      @info ||= Resource.new(collect_channel_info)
    end

    private

    def collect_channel_info
      data = about_section_info.merge(video_section_info)
      data[:channel_url] = channel_url
      data.select! { |_, v| v.present? }
    end

    def about_section_info
      @about_section_info ||= section(:about).info
    end

    def video_section_info
      @video_section_info ||= section(:videos).info
    end

    def channel_url
      uri = URI(client.class::BASE_URL)
      uri.path = options.channel_url

      uri.to_s
    rescue URI::InvalidComponentError
      options.channel_url
    end

    def section(title)
      constant_name = "YoutubeParser::Channels::#{title.capitalize}Section"
      opts = { channel_url: options.channel_url, client: client }
      Object.const_get(constant_name).new(opts)
    end
  end
end
