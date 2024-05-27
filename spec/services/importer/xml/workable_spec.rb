require 'rails_helper'

RSpec.describe Importer::Xml::Workable, type: :service, workable: true do
  describe "#import_xml", vcr: { cassette_name: 'workable_xml' } do
    let(:workable) { Importer::Xml::Workable.new }

    before do
      allow(ApplicantTrackingSystem).to receive(:find_by).with(name: 'Workable').and_return(double('ATS', url_xml: 'https://www.workable.com/boards/workable.xml'))
    end

    it "fetches and parses the XML data" do
      workable.import_xml
      expect(workable.job_posting_urls).not_to be_empty
    end
  end
end
