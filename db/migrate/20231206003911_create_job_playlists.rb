class CreateJobPlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :job_playlists do |t|
      t.string :name

      t.timestamps
    end
  end
end
