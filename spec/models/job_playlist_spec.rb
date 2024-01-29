RSpec.describe JobPlaylist do
  describe 'Associations' do
    it { is_expected.to have_many(:playlist_jobs).dependent(:destroy) }
    it { is_expected.to have_many(:jobs).through(:playlist_jobs) }
  end
end
