class RemoveAndAddUrlsToCompanies < ActiveRecord::Migration[7.1]
  def change
    remove_column :companies, :url_ats
    add_column :companies, :url_ats_main, :string
    add_column :companies, :url_ats_api, :string
  end
end
