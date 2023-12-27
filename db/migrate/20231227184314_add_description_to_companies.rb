class AddDescriptionToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :description, :string
  end
end
