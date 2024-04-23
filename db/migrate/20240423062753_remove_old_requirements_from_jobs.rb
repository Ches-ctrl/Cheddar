class RemoveOldRequirementsFromJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :create_account, :boolean
    remove_column :jobs, :req_cv, :boolean
    remove_column :jobs, :req_cover_letter, :boolean
    remove_column :jobs, :req_video_interview, :boolean
    remove_column :jobs, :req_online_assessment, :boolean
    remove_column :jobs, :req_first_round, :boolean
    remove_column :jobs, :req_second_round, :boolean
    remove_column :jobs, :req_assessment_centre, :boolean
    remove_column :jobs, :no_of_questions, :integer
    remove_column :jobs, :work_eligibility, :boolean
  end
end
