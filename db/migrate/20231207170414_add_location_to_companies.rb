class AddLocationToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :location, :string, default: 'n/a'
  end
end
