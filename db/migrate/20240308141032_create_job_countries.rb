class CreateJobCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :job_countries do |t|
      t.references :job, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
