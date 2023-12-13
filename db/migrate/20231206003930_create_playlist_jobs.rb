class CreatePlaylistJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_jobs do |t|
      t.references :job, null: false, foreign_key: true
      t.references :job_playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
