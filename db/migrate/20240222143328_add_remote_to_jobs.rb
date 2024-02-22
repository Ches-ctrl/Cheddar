class AddRemoteToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :remote, :boolean
  end
end
