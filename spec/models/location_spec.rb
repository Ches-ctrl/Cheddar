RSpec.describe Location do
  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:jobs) }
    it { is_expected.to belong_to(:country) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:city) }
  end
end
