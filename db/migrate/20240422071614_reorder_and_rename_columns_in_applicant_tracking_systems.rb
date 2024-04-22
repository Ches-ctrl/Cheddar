class ReorderAndRenameColumnsInApplicantTrackingSystems < ActiveRecord::Migration[7.1]
  def change
    remove_column :applicant_tracking_systems, :website_url
    remove_column :applicant_tracking_systems, :base_url_main
    remove_column :applicant_tracking_systems, :base_url_api
    remove_column :applicant_tracking_systems, :url_linkedin
    remove_column :applicant_tracking_systems, :url_all_jobs
    remove_column :applicant_tracking_systems, :url_xml
    remove_column :applicant_tracking_systems, :url_rss
    remove_column :applicant_tracking_systems, :login

    add_column :applicant_tracking_systems, :url_website, :string
    add_column :applicant_tracking_systems, :url_base, :string
    add_column :applicant_tracking_systems, :url_api, :string
    add_column :applicant_tracking_systems, :url_all_jobs, :string
    add_column :applicant_tracking_systems, :url_xml, :string
    add_column :applicant_tracking_systems, :url_rss, :string
    add_column :applicant_tracking_systems, :url_linkedin, :string
    add_column :applicant_tracking_systems, :login, :boolean, default: false
  end
end
