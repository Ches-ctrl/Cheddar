RSpec.describe JobApplication do
  describe 'Associations' do
    it { is_expected.to have_many(:application_responses).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:job) }
    it { is_expected.to have_one_attached(:screenshot) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:status) }
    xit { is_expected.to validate_uniqueness_of(:job_id).scoped_to(:user_id) }
  end
end
