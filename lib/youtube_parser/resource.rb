# frozen_string_literal: true

module YoutubeParser
  class Resource < OpenStruct
    def initialize(hash = {})
      @hash = hash
      @default_method_value = hash.delete(:default_method_value)

      super(hash)
    end

    def attributes
      @attributes ||= @hash.transform_keys(&:to_sym)
    end

    def method_missing(method, *args, &block)
      super_method = super
      return super_method if super_method

      @default_method_value
    end

    def respond_to_missing?(method_name, include_private = false)
      @hash.keys.include?(method_name) ||
        @hash.keys.map(&:to_s).include?(method_name) || super
    end
  end
end
