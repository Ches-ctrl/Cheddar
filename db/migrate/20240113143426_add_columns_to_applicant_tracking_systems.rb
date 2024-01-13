class AddColumnsToApplicantTrackingSystems < ActiveRecord::Migration[7.1]
  def change
    add_column :applicant_tracking_systems, :base_url_main, :string
    add_column :applicant_tracking_systems, :base_url_api, :string
    add_column :applicant_tracking_systems, :all_jobs_url, :string
  end
end
