RSpec.describe Country do
  describe 'Associations' do
    it { is_expected.to have_many(:locations) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
