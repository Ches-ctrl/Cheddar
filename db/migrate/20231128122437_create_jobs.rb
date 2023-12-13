class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.string :job_description, default: 'n/a'
      t.integer :salary
      t.date :date_created
      t.text :application_criteria
      t.date :application_deadline, default: Date.today + 1.day
      t.string :job_posting_url
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
