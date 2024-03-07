class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :city
      t.references :country, null: false, foreign_key: true
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end
  end
end
