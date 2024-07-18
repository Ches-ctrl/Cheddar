class CreateSavedSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_searches do |t|
      t.references :user, null: false, foreign_key: true
      t.jsonb :params, default: {}, null: false

      t.timestamps
    end
  end
end
