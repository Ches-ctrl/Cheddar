class AddColumnBackAndChangeColumnTypeForJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :ats_format_id, :integer
    change_column :jobs, :ats_job_id, :string
  end
end
