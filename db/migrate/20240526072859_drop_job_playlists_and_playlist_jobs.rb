class DropJobPlaylistsAndPlaylistJobs < ActiveRecord::Migration[7.1]
  def change
    drop_table :playlist_jobs
    drop_table :job_playlists
  end
end
