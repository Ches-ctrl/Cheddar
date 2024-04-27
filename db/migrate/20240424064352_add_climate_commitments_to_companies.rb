class AddClimateCommitmentsToCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :climate_commitments do |t|
      t.references :company, foreign_key: true
      t.string :data_source, null: false
      t.string :eunzdp_lei
      t.string :ox_id_code
      t.boolean :race_to_zero
      t.boolean :sbti_commitment
      t.string :interim_target
      t.string :final_target
      t.integer :interim_target_year
      t.integer :final_target_year
      t.boolean :scope_1
      t.boolean :scope_2
      t.boolean :scope_3
      t.string :source_url
      t.timestamps
    end
  end
end
