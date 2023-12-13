class AddFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :linkedin_profile, :string
    add_column :users, :address_first, :string
    add_column :users, :address_second, :string
    add_column :users, :post_code, :string
    add_column :users, :city, :string
    add_column :users, :phone_number, :string
    add_column :users, :github_profile_url, :string
    add_column :users, :website_url, :string
    add_column :users, :cover_letter_template_url, :string
  end
end
