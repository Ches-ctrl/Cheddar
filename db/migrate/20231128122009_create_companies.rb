class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_website_url
      t.string :company_category

      t.timestamps
    end
  end
end
