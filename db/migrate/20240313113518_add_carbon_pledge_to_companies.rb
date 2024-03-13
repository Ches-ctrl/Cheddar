class AddCarbonPledgeToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :carbon_pledge, :string
  end
end
