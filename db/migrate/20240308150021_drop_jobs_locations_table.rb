class DropJobsLocationsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :jobs_locations
  end
end
