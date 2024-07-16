# frozen_string_literal: true

class CreateApplicationCriteria < ActiveRecord::Migration[7.1]
  def change
    create_table :application_criteria do |t|
      t.references :job, null: false, foreign_key: true
      t.jsonb :form_structure, default: {}, null: false

      t.timestamps
    end
  end
end
