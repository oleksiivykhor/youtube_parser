# frozen_string_literal: true

module YoutubeParser
  class Client
    attr_reader :options

    BASE_URL = 'https://www.youtube.com/'
    DATA_REGEX = /window\[\"ytInitialData\"\]\s*\=\s*(\{[\w\W]+?\})\;/.freeze

    def initialize(options = {})
      @options = Resource.new(options)
    end

    def get(endpoint, options = {})
      response = client.get(endpoint, options)
      json_str = response.body[DATA_REGEX, 1]

      get_json json_str
    end

    private

    def client
      opts = { ssl: { verify: false }, request: { timeout: 10 } }
      @client ||= Faraday.new(BASE_URL, opts) do |request|
        request.adapter Faraday.default_adapter
        request.headers['User-Agent'] = options.user_agent if options.user_agent
        request.proxy = proxy if options.proxy
      end
    end

    def proxy
      URI(options.proxy)
    rescue URI::InvalidURIError
      URI("//#{options.proxy}")
    end

    def get_json(json_str)
      Oj.load(json_str)
    end
  end
end
