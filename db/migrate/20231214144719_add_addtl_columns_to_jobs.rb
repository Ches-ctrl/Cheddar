class AddAddtlColumnsToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :seniority, :string
    add_column :jobs, :applicants_count, :integer
    add_column :jobs, :cheddar_applicants_count, :integer
  end
end
