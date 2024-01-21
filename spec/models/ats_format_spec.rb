RSpec.describe AtsFormat do
  describe 'Associations' do
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
    it { is_expected.to belong_to(:applicant_tracking_system) }
  end

   describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    xit { is_expected.to validate_uniqueness_of(:name) }
   end
end
