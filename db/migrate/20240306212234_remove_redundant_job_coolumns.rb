class RemoveRedundantJobCoolumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :location
    remove_column :jobs, :city
    remove_column :jobs, :latitude
    remove_column :jobs, :longitude
    remove_column :jobs, :country
  end
end
