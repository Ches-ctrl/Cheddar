# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_07_084536) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applicant_tracking_systems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.string "base_url_main"
    t.string "base_url_api"
    t.string "all_jobs_url"
  end

  create_table "application_responses", force: :cascade do |t|
    t.bigint "job_application_id", null: false
    t.string "field_name"
    t.string "field_locator"
    t.string "field_value"
    t.string "field_option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "interaction"
    t.string "field_options"
    t.text "cover_letter_content"
    t.boolean "required"
    t.index ["job_application_id"], name: "index_application_responses_on_job_application_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.string "company_website_url"
    t.string "company_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location", default: "n/a"
    t.string "industry", default: "n/a"
    t.string "url_careers"
    t.string "url_linkedin"
    t.string "industry_subcategory", default: "n/a"
    t.bigint "applicant_tracking_system_id"
    t.string "ats_identifier"
    t.string "description"
    t.integer "total_live", default: 0
    t.string "url_ats_main"
    t.string "url_ats_api"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string "university"
    t.string "degree"
    t.string "field_study"
    t.integer "graduation_year"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_educations_on_user_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.string "status"
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_playlists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "job_title"
    t.string "job_description", default: "n/a"
    t.string "salary"
    t.date "date_created"
    t.text "application_criteria"
    t.date "application_deadline"
    t.string "job_posting_url"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "applicant_tracking_system_id"
    t.text "application_details"
    t.text "description_long"
    t.text "responsibilities"
    t.text "requirements"
    t.text "benefits"
    t.boolean "captcha", default: false
    t.string "employment_type", default: "Full-time"
    t.string "non_geocoded_location_string"
    t.string "industry"
    t.string "seniority"
    t.integer "applicants_count", default: 0
    t.integer "cheddar_applicants_count", default: 0
    t.integer "bonus"
    t.string "industry_subcategory"
    t.string "office_status"
    t.boolean "create_account", default: false
    t.boolean "req_cv", default: true
    t.boolean "req_cover_letter", default: false
    t.boolean "req_video_interview", default: false
    t.boolean "req_online_assessment", default: false
    t.boolean "req_first_round", default: true
    t.boolean "req_second_round", default: true
    t.boolean "req_assessment_centre", default: false
    t.boolean "live", default: false
    t.string "ats_job_id"
    t.integer "no_of_questions", default: 0
    t.boolean "work_eligibility", default: true
    t.string "department"
    t.string "api_url"
    t.string "office"
    t.boolean "remote_only"
    t.boolean "hybrid"
    t.string "role"
    t.index ["company_id"], name: "index_jobs_on_company_id"
  end

  create_table "jobs_locations", id: false, force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "location_id", null: false
  end

  create_table "jobs_technologies", id: false, force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "technology_id", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "city"
    t.bigint "country_id", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_locations_on_country_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.boolean "self"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "playlist_jobs", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "job_playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_playlist_jobs_on_job_id"
    t.index ["job_playlist_id"], name: "index_playlist_jobs_on_job_playlist_id"
  end

  create_table "saved_jobs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_saved_jobs_on_job_id"
    t.index ["user_id"], name: "index_saved_jobs_on_user_id"
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "linkedin_profile"
    t.string "address_first"
    t.string "address_second"
    t.string "post_code"
    t.string "city"
    t.string "phone_number"
    t.string "github_profile_url"
    t.string "website_url"
    t.string "cover_letter_template_url"
    t.boolean "admin", default: false, null: false
    t.string "salary_expectation_text"
    t.string "right_to_work"
    t.integer "salary_expectation_figure"
    t.integer "notice_period"
    t.string "preferred_pronoun_select"
    t.string "preferred_pronoun_text"
    t.string "employee_referral"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "application_responses", "job_applications"
  add_foreign_key "educations", "users"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "users"
  add_foreign_key "jobs", "applicant_tracking_systems"
  add_foreign_key "jobs", "companies"
  add_foreign_key "locations", "countries"
  add_foreign_key "playlist_jobs", "job_playlists"
  add_foreign_key "playlist_jobs", "jobs"
  add_foreign_key "saved_jobs", "jobs"
  add_foreign_key "saved_jobs", "users"
end
