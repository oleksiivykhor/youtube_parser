# frozen_string_literal: true

RSpec.describe YoutubeParser::Search::Channels do
  let(:query) { 'black sabbath' }
  let(:user_agent) do
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 '\
      '(KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36'
  end
  let(:channels) do
    described_class.new(search_query: query, user_agent: user_agent)
  end

  before do
    stub_request(:get, /[\w\W]*youtube.com[\w\W]*/).
      to_return(body: fixture('channels'))
    stub_request(:get, /[\w\W]*about/).
      to_return(body: fixture('channels/about_section'))
    stub_request(:get, /[\w\W]*videos/).
      to_return(body: fixture('channels/videos_section'))

    allow(channels).to receive(:continuation)
  end

  it { expect(channels.info).to be_a Array }
  it { expect(channels.info).to be_any }
  it { expect(channels.info).to all(be_a YoutubeParser::Resource) }

  it 'returns the block for each channel' do
    channels.for_each_channel do |channel|
      expect(channel).to be_a YoutubeParser::Resource
    end
  end
end
