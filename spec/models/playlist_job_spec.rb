RSpec.describe PlaylistJob do
  describe 'Associations' do
    it { is_expected.to belong_to(:job) }
    it { is_expected.to belong_to(:job_playlist) }
  end
end
