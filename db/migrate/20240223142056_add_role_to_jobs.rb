class AddRoleToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :role, :string
  end
end
