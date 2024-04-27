class ReorderAndAddColumnsOnJobs < ActiveRecord::Migration[7.1]
  def change
    # TODO: Migrate
    # ----------------------
    # remove current columns
    # ----------------------

    remove_column :jobs, :application_details

    # url strings
    remove_column :jobs, :ats_job_id, :string
    remove_column :jobs, :posting_url, :string
    remove_column :jobs, :api_url, :string

    # details and criteria
    remove_column :jobs, :live, :boolean
    remove_column :jobs, :date_posted, :date
    remove_column :jobs, :deadline, :date
    remove_column :jobs, :application_criteria, :text

    # job characteristics
    remove_column :jobs, :employment_type, :string
    remove_column :jobs, :seniority, :string
    remove_column :jobs, :industry, :string
    remove_column :jobs, :sub_industry, :string
    remove_column :jobs, :department, :string
    remove_column :jobs, :office, :string
    remove_column :jobs, :remote, :boolean
    remove_column :jobs, :hybrid, :boolean
    remove_column :jobs, :non_geocoded_location_string, :string

    # salary data
    remove_column :jobs, :salary, :string
    remove_column :jobs, :bonus, :integer

    # job description
    remove_column :jobs, :responsibilities, :text
    remove_column :jobs, :requirements, :text
    remove_column :jobs, :benefits, :text

    # applicants & cheddar status
    remove_column :jobs, :apply_with_cheddar, :boolean
    remove_column :jobs, :applicants_count, :integer
    remove_column :jobs, :cheddar_applicants_count, :integer

    # ----------------------
    # add columns back in the correct order
    # ----------------------

    # url strings
    add_column :jobs, :ats_job_id, :string
    add_column :jobs, :posting_url, :string
    add_column :jobs, :apply_url, :string
    add_column :jobs, :api_url, :string

    # details and criteria
    add_column :jobs, :live, :boolean, default: true
    add_column :jobs, :date_posted, :date
    add_column :jobs, :deadline, :date
    add_column :jobs, :application_criteria, :text

    # job description
    add_column :jobs, :responsibilities, :text
    add_column :jobs, :requirements, :text
    add_column :jobs, :benefits, :text

    # job characteristics
    add_column :jobs, :employment_type, :string, default: 'Full-time'
    add_column :jobs, :seniority, :string
    add_column :jobs, :industry, :string
    add_column :jobs, :sub_industry, :string
    add_column :jobs, :department, :string
    add_column :jobs, :office, :string
    add_column :jobs, :remote, :boolean
    add_column :jobs, :hybrid, :boolean
    add_column :jobs, :non_geocoded_location_string, :string

    # salary data
    add_column :jobs, :salary, :string
    add_column :jobs, :bonus, :integer

    # applicants & cheddar status
    add_column :jobs, :apply_with_cheddar, :boolean, default: false
    add_column :jobs, :applicants_count, :integer, default: 0
    add_column :jobs, :cheddar_applicants_count, :integer, default: 0
  end
end
