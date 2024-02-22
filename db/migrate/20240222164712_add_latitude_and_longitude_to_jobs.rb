class AddLatitudeAndLongitudeToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :latitude, :float
    add_column :jobs, :longitude, :float
  end
end
