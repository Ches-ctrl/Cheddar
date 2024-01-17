class AddDepartmentAndUrlToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :department, :string
    add_column :jobs, :api_url, :string
    change_column_default :jobs, :captcha, false
    remove_column :jobs, :ats_format_id
  end
end
