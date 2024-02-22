class RenameRemoteColumnInJobs < ActiveRecord::Migration[7.1]
  def change
    rename_column :jobs, :remote, :remote_only
  end
end
