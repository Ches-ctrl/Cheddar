RSpec.describe User do
  describe 'Associations' do
    it { is_expected.to have_many(:application_processes).dependent(:destroy) }
    it { is_expected.to have_many(:job_applications).through(:application_processes) }
    it { is_expected.to have_many(:saved_jobs).dependent(:destroy) }
    it { is_expected.to have_many(:educations).dependent(:destroy) }
    it { is_expected.to have_one_attached(:photo) }
    it { is_expected.to have_one_attached(:resume) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end
end
