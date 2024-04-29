RSpec.describe Requirement, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      requirement = build(:requirement)
      expect(requirement).to be_valid
    end

    it 'is not valid without a job' do
      requirement = build(:requirement, job: nil)
      expect(requirement).not_to be_valid
    end
  end
end
