class AddIndexToJobsOnApplicantTrackingSystemId < ActiveRecord::Migration[7.1]
  def change
    add_index :jobs, :applicant_tracking_system_id
  end
end
