class ReorderAndRenameColumnsInJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :description_long, :text
    remove_column :jobs, :captcha, :boolean
    remove_column :jobs, :office_status, :string

    rename_column :jobs, :job_title, :title
    rename_column :jobs, :job_description, :description
    rename_column :jobs, :job_posting_url, :posting_url
    rename_column :jobs, :application_deadline, :deadline
    rename_column :jobs, :industry_subcategory, :sub_industry
    rename_column :jobs, :date_created, :date_posted
    rename_column :jobs, :remote_only, :remote
  end
end
