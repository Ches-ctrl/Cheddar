class ReorderAndRenameColumnsInJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :description_long, :text
    remove_column :jobs, :captcha, :boolean
    remove_column :jobs, :office_status, :string

    rename_column :jobs, :job_title, :title
    rename_column :jobs, :job_description, :description
    rename_column :jobs, :job_posting_url, :url_posting
    rename_column :jobs, :application_deadline, :deadline
    rename_column :jobs, :industry_subcategory, :sub_industry
    rename_column :jobs, :api_url, :url_api
    rename_column :jobs, :date_created, :date_posted
    rename_column :jobs, :remote_only, :remote

    change_column_default :jobs, :live, from: false, to: true
  end
end

# TODO: Move application_requirements into a separate table
# TODO: add description_html?

# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.bigint "company_id", null: false
# t.integer "applicant_tracking_system_id"

# t.string "url_posting"
# t.string "url_api"
# t.string "ats_job_id"

# t.string "employment_type", default: "Full-time"
# t.string "seniority"
# t.string "industry"
# t.string "sub_industry"
# t.string "department"
# t.string "office"
# t.boolean "remote"
# t.boolean "hybrid"

# t.boolean "live", default: true
# t.date "date_posted"
# t.date "deadline"
# t.text "application_criteria"

# t.string "salary"
# t.integer "bonus"

# t.text "application_details"
# t.text "responsibilities"
# t.text "requirements"
# t.text "benefits"

# t.index ["company_id"], name: "index_jobs_on_company_id"

# t.boolean "work_eligibility", default: true

# t.boolean "apply_with_cheddar", default: false
# t.integer "applicants_count", default: 0
# t.integer "cheddar_applicants_count", default: 0

# t.string "non_geocoded_location_string"

# t.integer "no_of_questions", default: 0
# t.boolean "create_account", default: false
# t.boolean "req_cv", default: true
# t.boolean "req_cover_letter", default: false
# t.boolean "req_video_interview", default: false
# t.boolean "req_online_assessment", default: false
# t.boolean "req_first_round", default: true
# t.boolean "req_second_round", default: true
# t.boolean "req_assessment_centre", default: false
