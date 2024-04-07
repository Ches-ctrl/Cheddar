class AddFieldsToApplicantTrackingSystem < ActiveRecord::Migration[7.1]
  def change
    add_column :applicant_tracking_systems, :url_identifier, :string
    add_column :applicant_tracking_systems, :url_linkedin, :string
    add_column :applicant_tracking_systems, :url_all_jobs, :string
    add_column :applicant_tracking_systems, :url_xml, :string
    add_column :applicant_tracking_systems, :url_rss, :string
    add_column :applicant_tracking_systems, :login, :boolean
  end
end
