class AddColumnsToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :employment_type, :string
    add_column :jobs, :location, :string
    add_column :jobs, :country, :string
    add_column :jobs, :industry, :string
  end
end
