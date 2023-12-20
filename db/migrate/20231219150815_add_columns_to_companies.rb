class AddColumnsToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :url_careers, :string
    add_column :companies, :url_linkedin, :string
    add_column :companies, :industry_subcategory, :string, default: "n/a"
  end
end
