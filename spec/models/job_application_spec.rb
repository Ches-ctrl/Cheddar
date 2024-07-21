RSpec.describe JobApplication do
  describe 'Associations' do
    it { is_expected.to belong_to(:application_process) }
    it { is_expected.to belong_to(:job) }
  end

  describe 'Validations' do
    it { is_expected.to validate_inclusion_of(:status).in_array(JobApplication.statuses.keys) }

    xit { is_expected.to validate_uniqueness_of(:job_id).scoped_to(:user_id) }
  end
end
