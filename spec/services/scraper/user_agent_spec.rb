require 'rails_helper'

RSpec.describe Scraper::UserAgent, type: :service, user_agent: true do
  let(:user_agent_service) { described_class.new }

  before do
    allow(File).to receive(:read).with(anything).and_return('{}')
    allow(File).to receive(:write).with(anything, anything)
  end

  describe '#create_agent' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe '#create_header' do
    it 'creates a header with a valid User-Agent' do
      allow(user_agent_service).to receive(:create_agent).and_return('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
      header = user_agent_service.create_header
      expect(header).to eq({ 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36' })
    end
  end
end
