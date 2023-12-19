class AddAppStepColumnsToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :bonus, :integer
    add_column :jobs, :industry_subcategory, :string
    add_column :jobs, :office_status, :string
    add_column :jobs, :create_account, :boolean
    add_column :jobs, :req_cv, :boolean, default: true
    add_column :jobs, :req_cover_letter, :boolean
    add_column :jobs, :req_video_interview, :boolean
    add_column :jobs, :req_online_assessment, :boolean
    add_column :jobs, :req_first_round, :boolean, default: true
    add_column :jobs, :req_second_round, :boolean, default: true
    add_column :jobs, :assessment_centre, :boolean
  end
end
