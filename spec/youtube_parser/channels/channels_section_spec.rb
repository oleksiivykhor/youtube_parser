# frozen_string_literal: true

RSpec.describe YoutubeParser::Channels::ChannelsSection do
  let(:channel_url) { 'https://www.youtube.com/user/google' }
  let(:user_agent) do
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
      '(KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36'
  end
  let(:channels) do
    described_class.new(channel_url: channel_url, user_agent: user_agent)
  end

  before do
    stub_request(:get, /[\w\W]*channels[\w\W]*/).
      to_return(body: fixture('channels/channels_section'))
    stub_request(:get, /[\w\W]*about/).
      to_return(body: fixture('channels/about_section'))
    stub_request(:get, /[\w\W]*videos/).
      to_return(body: fixture('channels/videos_section'))
  end

  it { expect(channels.info).to be_a Array }
  it { expect(channels.info).to all(be_a YoutubeParser::Resource) }
end
