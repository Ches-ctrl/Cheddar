RSpec.describe Importer::Api::TrueUp, type: :service do
  before do
    allow(ApplicantTrackingSystem).to receive(:find_by).with(name: 'TrueUp').and_return(double('ATS', name: 'TrueUp', url_all_jobs: 'https://XXX-dsn.algolia.net/1/indexes/*/queries'))
    allow_any_instance_of(LocalDataStorer).to receive(:fetch_local_data).and_return(nil)
  end

  it 'fetches some number of jobs', :vcr do
    VCR.use_cassette('true_up') do
      expect { subject.call }.to output(/Fetched (\d+) jobs from TrueUp/).to_stdout
    end
  end

  describe '#extract_jobs_from_data' do
    context 'With valid data' do
      let(:data) { { 'results' => [{ 'hits' => [{job_id: 1}, {job_id: 2}] }, { 'hits' => [{job_id: 3}, {job_id: 4}] } ] } }
      let(:expected_jobs) { [{job_id: 1}, {job_id: 2}, {job_id: 3}, {job_id: 4}] }

      it 'extracts jobs from the data' do
        subject.instance_variable_set(:@data, data)

        expect(subject.send(:extract_jobs_from_data)).to eq(expected_jobs)
      end
    end

    context 'With invalid data' do
      let(:data) { {} }

      it 'returns an empty array' do
        expect(subject.send(:extract_jobs_from_data)).to eq([])
      end
    end
  end
end
