RSpec.describe Importer::Api::DevitJobs, type: :service, devitjobs: true do
  let(:service) { described_class.new }

  before do
    allow(ApplicantTrackingSystem).to receive(:find_by).with(name: 'DevITJobs').and_return(double('ATS', url_all_jobs: 'https://devitjobs.uk/api/jobsLight'))
  end

  describe '#import_jobs', :vcr do
    it 'fetches the JSON data' do
      VCR.use_cassette('devit_jobs') do
        jobs_data = service.send(:fetch_json, 'https://devitjobs.uk/api/jobsLight')
        expect(jobs_data).to be_an(Array)
        expect(jobs_data).not_to be_empty
      end
    end

    it 'finds at least one redirect URL' do
      skip 'This test is not yet implemented'
    end
  end
end
