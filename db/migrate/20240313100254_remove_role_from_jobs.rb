class RemoveRoleFromJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :role, :string
  end
end
