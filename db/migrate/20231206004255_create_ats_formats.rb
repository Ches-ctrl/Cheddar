class CreateAtsFormats < ActiveRecord::Migration[7.1]
  def change
    create_table :ats_formats do |t|
      t.references :applicant_tracking_system, null: false, foreign_key: true
      t.string :core_input_key
      t.string :interaction
      t.string :locator
      t.string :option

      t.timestamps
    end
  end
end
