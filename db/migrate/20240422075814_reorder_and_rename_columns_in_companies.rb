class ReorderAndRenameColumnsInCompanies < ActiveRecord::Migration[7.1]
  def change
    rename_column :companies, :company_name, :name

    remove_column :companies, :company_website_url, :string
    remove_column :companies, :company_category, :string # removed and replaced with industry and sub_industry
    remove_column :companies, :location, :string
    remove_column :companies, :industry, :string
    remove_column :companies, :url_careers, :string
    remove_column :companies, :url_linkedin, :string
    remove_column :companies, :industry_subcategory, :string
    remove_column :companies, :total_live, :integer
    remove_column :companies, :url_ats_main, :string
    remove_column :companies, :url_ats_api, :string
    remove_column :companies, :carbon_pledge, :string

    add_column :companies, :url_website, :string # renamed from company_website_url
    add_column :companies, :url_careers, :string
    add_column :companies, :url_linkedin, :string
    add_column :companies, :url_ats_main, :string
    add_column :companies, :url_ats_api, :string
    add_column :companies, :location, :string, default: "n/a"
    add_column :companies, :industry, :string, default: "n/a"
    add_column :companies, :sub_industry, :string, default: "n/a"
    add_column :companies, :total_live, :integer, default: 0
    add_column :companies, :carbon_pledge, :string
  end
end
