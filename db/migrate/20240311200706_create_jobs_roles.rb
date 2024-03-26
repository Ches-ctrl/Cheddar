class CreateJobsRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs_roles do |t|
      t.references :role, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
 end
end
