class AddApplicantTrackingSystemAndAtsFormatToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :applicant_tracking_system_id, :integer
    add_column :jobs, :ats_format_id, :integer

    add_foreign_key :jobs, :applicant_tracking_systems
    add_foreign_key :jobs, :ats_formats
  end
end
