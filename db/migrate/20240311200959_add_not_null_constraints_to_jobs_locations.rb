class AddNotNullConstraintsToJobsLocations < ActiveRecord::Migration[7.1]
  def change
    change_column_null :jobs_locations, :job_id, false
    change_column_null :jobs_locations, :location_id, false
  end
end
