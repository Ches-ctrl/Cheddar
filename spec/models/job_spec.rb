RSpec.describe Job do
  describe 'Associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:applicant_tracking_system).optional(:true) }
    it { is_expected.to have_many(:playlist_jobs) }
    it { is_expected.to have_many(:job_playlists).through(:playlist_jobs) }
    it { is_expected.to have_many(:job_applications).dependent(:destroy) }
    it { is_expected.to have_many(:saved_jobs).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:job_title) }
    it { is_expected.to validate_presence_of(:job_posting_url) }
    xit { is_expected.to validate_uniqueness_of(:job_posting_url) }
  end

  describe '.search_jobs' do
   before do
     create(:job, job_title: 'Junior Golang Developer') # create two job objects
     create(:job, job_title: 'Ruby on Rails Developer')
     create(:job, job_title: 'Devops Engineer')
   end

   it { expect(described_class.search_job('Ruby')).to eq [Job.second] }
  end
end
