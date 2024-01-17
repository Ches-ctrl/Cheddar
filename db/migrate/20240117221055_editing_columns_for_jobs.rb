class EditingColumnsForJobs < ActiveRecord::Migration[7.1]
  def change
    change_column_default :jobs, :employment_type, "Full-time"
    change_column_default :jobs, :applicants_count, 0
    change_column_default :jobs, :cheddar_applicants_count, 0
    change_column_default :jobs, :create_account, false
    change_column_default :jobs, :req_cv, true
    change_column_default :jobs, :req_cover_letter, false
    change_column_default :jobs, :req_video_interview, false
    change_column_default :jobs, :req_online_assessment, false
    change_column_default :jobs, :req_assessment_centre, false
    add_column :jobs, :no_of_questions, :integer, default: 0
    add_column :jobs, :work_eligibility, :boolean, default: true
  end
end
