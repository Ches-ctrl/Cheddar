require 'rails_helper'

RSpec.describe Importer::Api::DevitJobs, type: :service, devitjobs: true do
  let(:service) { described_class.new }

  before do
    allow(ApplicantTrackingSystem).to receive(:find_by).with(name: 'DevITJobs').and_return(double('ATS', url_all_jobs: 'https://devitjobs.uk/api/jobsLight'))
    allow_any_instance_of(Importer::Api::DevitJobs).to receive(:create_company).and_return(double('Company', name: 'Test Company'))
    allow_any_instance_of(Importer::Api::DevitJobs).to receive(:create_job).and_return(double('Job', title: 'Test Job', company: double('Company', name: 'Test Company')))
  end

  describe '#import_jobs', :vcr do
    it 'fetches the JSON data' do
      VCR.use_cassette('devit_jobs') do
        jobs_data = service.send(:fetch_jobs_data)
        expect(jobs_data).to be_an(Array)
        expect(jobs_data).not_to be_empty
      end
    end

    it 'creates one company' do
      VCR.use_cassette('devit_jobs') do
        service.import_jobs
        expect(service).to have_received(:create_company).at_least(:once)
      end
    end

    it 'creates one job' do
      VCR.use_cassette('devit_jobs') do
        service.import_jobs
        expect(service).to have_received(:create_job).at_least(:once)
      end
    end

    it 'finds at least one redirect URL' do
      VCR.use_cassette('devit_jobs') do
        service.import_jobs
        expect(service.instance_variable_get(:@redirect_urls)).not_to be_empty
      end
    end
  end
end
