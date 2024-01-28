RSpec.describe ApplicationResponse do
  describe 'Associations' do
    it { is_expected.to belong_to(:job_application) }
  end
end
