RSpec.describe User do
  describe 'Associations' do
    it { is_expected.to have_many(:job_applications).dependent(:destroy) }
    it { is_expected.to have_many(:saved_jobs).dependent(:destroy) }
    it { is_expected.to have_many(:educations).dependent(:destroy) }
    it { is_expected.to have_many(:jobs).through(:job_applications) }
    it { is_expected.to have_one_attached(:photo) }
    it { is_expected.to have_one_attached(:resume) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end
end
