class AddIndexToJobsTechnologiesOnTechnologyId < ActiveRecord::Migration[7.1]
  def change
    add_index :jobs_technologies, :technology_id
  end
end
