class AddIndexToCompaniesOnApplicantTrackingSystemId < ActiveRecord::Migration[7.1]
  def change
    add_index :companies, :applicant_tracking_system_id
  end
end
