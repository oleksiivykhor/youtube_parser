# frozen_string_literal: true

module YoutubeParser
  module Channels
    class AboutSection < BaseParser
      options :channel_url

      def info
        {
          title: title,
          email: email,
          description: description,
          country: country,
          tags: tags,
          views_count: views_count,
          followers_count: followers_count,
          videos_count: videos_count,
          avatar_url: avatar_url
        }
      end

      private

      def title
        section.dig(*keys.title)
      end

      def email
        regex = /#{URI::MailTo::EMAIL_REGEXP.source.gsub(/\\A|\\z/, '')}/
        description[regex]
      end

      def description
        descriptions = [section.dig(*keys.description_first),
                        section.dig(*keys.description_second)]
        descriptions.compact.join(' ')
      end

      def country
        section.dig(*keys.country)
      end

      def tags
        json.dig(*keys.keywords).to_s.split('"').select(&:present?)
      end

      def avatar_url
        results = json.dig(*keys.meta_avatar) || section.dig(*keys.avatar)
        return if results.nil? || results.empty?

        results.detect { |t| t&.dig('url') }&.dig('url')
      end

      def views_count
        views_str = section.dig(*keys.views)&.map(&:values)&.join
        return unless views_str

        (views_str.gsub(/\D+/, '') || statistics(:views_count))
      end

      def followers_count
        count = scrape_subscribers_count
        count.present? ? count : statistics(:followers_count)
      end

      def videos_count
        statistics :videos_count
      end

      def statistics(title)
        indexes = { videos_count: 1, views_count: 2, followers_count: 3 }
        stats = section.dig(*keys.statistics) || []

        stats[indexes[title.to_sym].to_i].to_s.gsub(/\D+/, '')
      end

      def scrape_subscribers_count
        return unless subscribers_match

        number = subscribers_match[:number].gsub(',', '.').to_f
        return number.to_i unless subscribers_match[:units].present?

        subscribers_with_units number
      end

      def subscribers_with_units(number)
        (number * units[subscribers_match[:units].downcase.to_sym]).to_i
      end

      def subscribers_match
        regex = /(?<number>[\d.,]+)(?<units>\w?)/
        subscribers_text = json.dig(*keys.subscribers_count_text).to_s
        subscribers_text.match(regex)
      end

      def units
        { m: 1_000_000, k: 1_000 }
      end

      def section
        return @section if @section

        @section = json.dig(*keys.section_tabs)&.detect do |tab|
          tab.dig(*keys.about_section_tab)
        end
        @section = @section&.dig(*keys.about_section_tab) || {}
      end

      def json
        @json ||= client.get("#{options.channel_url}/about")
      end
    end
  end
end
