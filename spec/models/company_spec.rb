RSpec.describe Company do
  describe 'Associations' do
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
    it { is_expected.to belong_to(:applicant_tracking_system).optional(true) }
  end

  describe 'Validations', :vcr do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:ats_identifier) }
  end
end
