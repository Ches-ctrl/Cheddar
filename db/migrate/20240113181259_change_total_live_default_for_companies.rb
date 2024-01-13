class ChangeTotalLiveDefaultForCompanies < ActiveRecord::Migration[7.1]
  def change
    change_column_default :companies, :total_live, 0
  end
end
