class AddAtsSystemToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :applicant_tracking_system_id, :bigint
    add_column :companies, :url_ats, :string
    add_column :companies, :ats_identifier, :string
  end
end
