require 'webmock/rspec'

RSpec.describe ApplicationService, type: :service, application_service: true do
  let(:service) { described_class.new }
  let(:json_url) { 'https://api.example.com/data.json' }
  let(:xml_url) { 'https://api.example.com/data.xml' }
  let(:large_xml_url) { 'https://api.example.com/large.xml' }
  let(:json_response) { { key: 'value' }.to_json }
  let(:xml_response) { '<root><element>value</element></root>' }
  let(:malformed_xml_response) { '<root><element>value</element>' }
  let(:large_xml_response) { '<root><job_posting_url>https://apply.workable.com/j/9A5B371BA0</job_posting_url></root>' }

  before do
    allow(Rails.logger).to receive(:error)
  end

  describe '#fetch_json' do
    context 'when the request is successful' do
      before do
        stub_request(:get, json_url).to_return(body: json_response, headers: { 'Content-Type' => 'application/json' })
      end

      it 'fetches and parses the JSON data' do
        result = service.fetch_json(json_url)
        expect(result).to eq({ 'key' => 'value' })
      end
    end

    context 'when the JSON is malformed' do
      before do
        stub_request(:get, json_url).to_return(body: 'invalid_json', headers: { 'Content-Type' => 'application/json' })
      end

      it 'logs the error and returns nil' do
        result = service.fetch_json(json_url)
        expect(result).to be_nil
        expect(Rails.logger).to have_received(:error).with(/Failed to parse JSON/)
      end
    end
  end

  describe '#fetch_xml' do
    context 'when the request is successful' do
      before do
        stub_request(:get, xml_url).to_return(body: xml_response, headers: { 'Content-Type' => 'application/xml' })
      end

      it 'fetches and parses the XML data' do
        result = service.fetch_xml(xml_url)
        expect(result.at_xpath('//element').text).to eq('value')
      end
    end
  end

  describe '#stream_xml' do
    pending 'add tests for streaming XML data'
  end
end
