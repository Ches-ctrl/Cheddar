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

ActiveRecord::Schema[7.1].define(version: 2024_05_26_072859) do
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
    t.string "url_identifier"
    t.string "url_website"
    t.string "url_base"
    t.string "url_api"
    t.string "url_all_jobs"
    t.string "url_xml"
    t.string "url_rss"
    t.string "url_linkedin"
    t.boolean "login", default: false
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
    t.boolean "required"
    t.string "field_label"
    t.boolean "core_field"
    t.index ["job_application_id"], name: "index_application_responses_on_job_application_id"
  end

  create_table "climate_commitments", force: :cascade do |t|
    t.bigint "company_id"
    t.string "data_source", null: false
    t.string "eunzdp_lei"
    t.string "ox_id_code"
    t.boolean "race_to_zero"
    t.boolean "sbti_commitment"
    t.string "interim_target"
    t.string "final_target"
    t.integer "interim_target_year"
    t.integer "final_target_year"
    t.boolean "scope_1"
    t.boolean "scope_2"
    t.boolean "scope_3"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_climate_commitments_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "applicant_tracking_system_id"
    t.string "ats_identifier"
    t.string "description"
    t.string "url_website"
    t.string "url_careers"
    t.string "url_linkedin"
    t.string "url_ats_main"
    t.string "url_ats_api"
    t.string "location", default: "n/a"
    t.string "industry", default: "n/a"
    t.string "sub_industry", default: "n/a"
    t.integer "total_live", default: 0
    t.string "carbon_pledge"
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

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "job_boards", force: :cascade do |t|
    t.string "name"
    t.string "url_identifier"
    t.string "url_website"
    t.string "url_base"
    t.string "url_api"
    t.string "url_all_jobs"
    t.string "url_xml"
    t.string "url_rss"
    t.string "url_linkedin"
    t.boolean "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.string "description", default: "n/a"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "applicant_tracking_system_id"
    t.string "ats_job_id"
    t.string "posting_url"
    t.string "apply_url"
    t.string "api_url"
    t.boolean "live", default: true
    t.date "date_posted"
    t.date "deadline"
    t.text "application_criteria"
    t.text "responsibilities"
    t.text "requirements"
    t.text "benefits"
    t.string "employment_type", default: "Full-time"
    t.string "seniority"
    t.string "industry"
    t.string "sub_industry"
    t.string "department"
    t.string "office"
    t.boolean "remote"
    t.boolean "hybrid"
    t.string "non_geocoded_location_string"
    t.string "salary"
    t.integer "bonus"
    t.boolean "apply_with_cheddar", default: false
    t.integer "applicants_count", default: 0
    t.integer "cheddar_applicants_count", default: 0
    t.index ["company_id"], name: "index_jobs_on_company_id"
  end

  create_table "jobs_countries", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_jobs_countries_on_country_id"
    t.index ["job_id"], name: "index_jobs_countries_on_job_id"
  end

  create_table "jobs_locations", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_jobs_locations_on_job_id"
    t.index ["location_id"], name: "index_jobs_locations_on_location_id"
  end

  create_table "jobs_roles", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_jobs_roles_on_job_id"
    t.index ["role_id"], name: "index_jobs_roles_on_role_id"
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

  create_table "requirements", force: :cascade do |t|
    t.bigint "job_id"
    t.boolean "work_eligibility"
    t.string "difficulty"
    t.integer "no_of_qs", default: 0
    t.boolean "create_account", default: false
    t.boolean "resume", default: true
    t.boolean "cover_letter", default: false
    t.boolean "video_interview", default: false
    t.boolean "online_assessment", default: false
    t.boolean "first_round", default: true
    t.boolean "second_round", default: true
    t.boolean "third_round", default: false
    t.boolean "assessment_centre", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_requirements_on_job_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_jobs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_saved_jobs_on_job_id"
    t.index ["user_id"], name: "index_saved_jobs_on_user_id"
  end

  create_table "sub_industries", force: :cascade do |t|
    t.string "name"
    t.bigint "industry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_sub_industries_on_industry_id"
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
  add_foreign_key "climate_commitments", "companies"
  add_foreign_key "educations", "users"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "users"
  add_foreign_key "jobs", "applicant_tracking_systems"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs_countries", "countries"
  add_foreign_key "jobs_countries", "jobs"
  add_foreign_key "jobs_locations", "jobs"
  add_foreign_key "jobs_locations", "locations"
  add_foreign_key "jobs_roles", "jobs"
  add_foreign_key "jobs_roles", "roles"
  add_foreign_key "locations", "countries"
  add_foreign_key "requirements", "jobs"
  add_foreign_key "saved_jobs", "jobs"
  add_foreign_key "saved_jobs", "users"
  add_foreign_key "sub_industries", "industries"
end
