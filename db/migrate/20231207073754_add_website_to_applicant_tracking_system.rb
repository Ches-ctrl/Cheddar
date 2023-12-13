class AddWebsiteToApplicantTrackingSystem < ActiveRecord::Migration[7.1]
  def change
    add_column :applicant_tracking_systems, :website_url, :string
  end
end
