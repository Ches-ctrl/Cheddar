class CreateApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :application_responses do |t|
      t.references :job_application, null: false, foreign_key: true
      t.string :field_name
      t.string :field_locator
      t.string :field_value
      t.string :field_option

      t.timestamps
    end
  end
end
