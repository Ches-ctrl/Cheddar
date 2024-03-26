class CreateJoinTableJobsLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs_locations do |t|
      t.references :job, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
