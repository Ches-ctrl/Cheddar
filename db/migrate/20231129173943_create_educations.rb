class CreateEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :educations do |t|
      t.string :university
      t.string :degree
      t.string :field_study
      t.integer :graduation_year
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
