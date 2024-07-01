class CreateUserDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :user_details do |t|
      t.references :user, null: false, foreign_key: true
      t.jsonb :info, default: {}, null: false
      t.timestamps
    end
  end
end
