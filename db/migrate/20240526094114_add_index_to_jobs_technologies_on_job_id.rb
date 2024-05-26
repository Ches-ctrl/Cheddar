class AddIndexToJobsTechnologiesOnJobId < ActiveRecord::Migration[7.1]
  def change
    add_index :jobs_technologies, :job_id
  end
end
