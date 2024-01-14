class AddAndRemoveColumnsFromJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :ats_format_id
    remove_column :jobs, :application_process
    add_column :jobs, :ats_job_id, :integer
  end
end
