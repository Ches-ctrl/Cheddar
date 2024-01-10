class AddTotalLiveToCompany < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :total_live, :integer
  end
end
