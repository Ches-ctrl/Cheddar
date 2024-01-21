RSpec.describe Education do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end
end
