class AddIndustryToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :industry, :string, default: 'n/a'
  end
end
