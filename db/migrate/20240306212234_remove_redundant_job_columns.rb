class RemoveRedundantJobColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :jobs, :location, :non_geocoded_location_string
    remove_column :jobs, :city
    remove_column :jobs, :latitude
    remove_column :jobs, :longitude
    remove_column :jobs, :country
  end
end
