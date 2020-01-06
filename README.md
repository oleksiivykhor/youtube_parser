# YoutubeParser
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'youtube_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install youtube_parser

## Usage

To fetch youtube channel info:
```ruby
require 'youtube_parser'

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
    '(KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36'
options = { channel_url: 'https://www.youtube.com/channel/channel_id',
            user_agent: user_agent }

YoutubeParser::Channel.new(options).info
```

To search channels by query:
```ruby
require 'youtube_parser'

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
    '(KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36'
options = { search_query: 'search query',
            user_agent: user_agent }

# Search with pagination
YoutubeParser::Search::Channels.new(options).for_each_channel do |channel|
  channel
end

# First page channels
YoutubeParser::Search::Channels.new(options).info
```

To parse channel related channels:
```ruby
require 'youtube_parser'

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
    '(KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36'
options = { search_query: 'search query',
            user_agent: user_agent }

YoutubeParser::Channels::ChannelsSection.new(options).info
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/youtube_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YoutubeParser project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/youtube_parser/blob/master/CODE_OF_CONDUCT.md).
