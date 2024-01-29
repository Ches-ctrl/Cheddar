RSpec.describe ApplicantTrackingSystem do
  describe 'Associations' do
    it { is_expected.to have_many(:companies) }
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
