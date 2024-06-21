# frozen_string_literal: true

class CreateNewJobApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :job_applications do |t|
      t.references :application_process, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.jsonb :additional_info, null: false, default: {}
      t.string :status, null: false, default: "new"
      t.timestamps
    end
  end
end
