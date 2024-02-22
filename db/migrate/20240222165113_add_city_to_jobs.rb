class AddCityToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :city, :string
  end
end
