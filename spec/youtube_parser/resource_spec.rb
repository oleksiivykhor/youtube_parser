# frozen_string_literal: true

RSpec.describe YoutubeParser::Resource do
  let(:hash) { {} }
  let(:resource) { described_class.new(hash) }

  it 'returns nil on nonexistent method calling without '\
    ':default_method_value key' do
    expect(resource.invalid_method).to be_nil
    expect(resource).not_to respond_to :default_method_value
  end

  context 'with :default_method_value_key' do
    let(:hash) { { default_method_value: [] } }

    it 'returns [] on nonexistent method calling' do
      expect(resource.invalid_method).to eq []
    end
  end

  describe '#attributes' do
    let(:hash) { { symbol_key: :symbol, 'string_key' => 'string' } }
    let(:result) { { symbol_key: :symbol, string_key: 'string' } }

    it 'returns hash with symbolized keys' do
      expect(resource.attributes).to eq result
    end
  end
end
