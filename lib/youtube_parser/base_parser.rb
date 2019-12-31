# frozen_string_literal: true

module YoutubeParser
  class BaseParser
    attr_reader :options

    def initialize(options = {})
      @options = Resource.new(options)

      required_options.each do |option|
        message = "missing keyword: #{option}"

        raise ArgumentError, message unless @options.public_send(option)
      end
    end

    def resource
      @resource ||= Resource.new(info)
    end

    def info
      raise NotImplementedError
    end

    def self.options(*opts)
      define_method(:required_options) { opts }
    end

    private

    def keys
      return @keys if @keys

      path = YoutubeParser.root.join('lib/youtube_parser/config/keys.yml')
      @keys = Resource.new(YAML.load_file(path).merge(default_method_value: []))
    end

    def client
      @client ||= options.client || Client.new(options.attributes)
    end

    # Default definition
    def required_options
      []
    end
  end
end
