require 'rails_helper'

RSpec.describe Importer::Xml::WorkableParserJob, type: :job do
  describe '#perform' do
    it 'calls import_jobs on WorkableParser' do
      parser = instance_double("Importer::Xml::WorkableParser")
      allow(Importer::Xml::WorkableParser).to receive(:new).and_return(parser)
      expect(parser).to receive(:import_jobs)

      described_class.perform_now
    end
  end
end