require 'rails_helper'

RSpec.describe Importer::Xml::Workable, type: :service, workable: true do
  describe "#import_xml" do
    pending "Add tests for Workable XML import"
    # let(:workable) { Importer::Xml::Workable.new }
    # let(:xml_url) { 'https://www.workable.com/boards/workable.xml' }
    # let(:sample_xml_path) { Rails.root.join('spec/fixtures/sample_workable.xml') }
    # let(:sample_xml) { File.read(sample_xml_path) }
    # let(:ats_double) { double('ATS', url_xml: xml_url, name: 'Workable') }

    # before do
    #   allow(ApplicantTrackingSystem).to receive(:find_by).with(name: 'Workable').and_return(ats_double)
    #   stub_request(:get, xml_url).to_return(body: sample_xml, headers: { 'Content-Type' => 'application/xml' })
    # end

    # context "when the XML is fetched successfully" do
    #   it "fetches and parses the XML data" do
    #     job_posting_urls = workable.import_xml
    #     expect(job_posting_urls.count).to eq(1)
    #     expect(job_posting_urls.first).to eq('https://apply.workable.com/j/2CF1C90531')
    #   end
    # end
  end
end
