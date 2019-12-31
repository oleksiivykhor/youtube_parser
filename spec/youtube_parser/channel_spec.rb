# frozen_string_literal: true

RSpec.describe YoutubeParser::Channel do
  let(:channel_url) { 'https://www.youtube.com/user/google' }
  let(:user_agent) do
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
      '(KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36'
  end
  let(:channel) do
    described_class.new(channel_url: channel_url, user_agent: user_agent)
  end

  before do
    stub_request(:get, "#{channel_url}/about").
      to_return(body: fixture('channels/about_section'))
    stub_request(:get, "#{channel_url}/videos").
      to_return(body: fixture('channels/videos_section'))
  end

  it { expect(channel.info).to be_a YoutubeParser::Resource }
end
