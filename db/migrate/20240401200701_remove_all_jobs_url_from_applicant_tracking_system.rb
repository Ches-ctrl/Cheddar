class RemoveAllJobsUrlFromApplicantTrackingSystem < ActiveRecord::Migration[7.1]
  def change
    remove_column :applicant_tracking_systems, :all_jobs_url, :string
  end
end
