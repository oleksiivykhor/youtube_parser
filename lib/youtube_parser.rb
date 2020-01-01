# frozen_string_literal: true

require 'uri'
require 'oj'
require 'faraday'
require 'ostruct'
require 'yaml'
require 'pathname'
require 'active_support'
require 'active_support/core_ext'

require 'youtube_parser/version'
require 'youtube_parser/resource'
require 'youtube_parser/client'
require 'youtube_parser/base_parser'
require 'youtube_parser/channel'
require 'youtube_parser/channels/about_section'
require 'youtube_parser/channels/videos_section'
require 'youtube_parser/search/channels'

module YoutubeParser
  def self.root
    Pathname.new(Dir.pwd)
  end
end
