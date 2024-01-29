RSpec.describe SavedJob do
  describe 'Associations' do
    it { is_expected.to belong_to(:job) }
    it { is_expected.to belong_to(:user) }
  end
end
