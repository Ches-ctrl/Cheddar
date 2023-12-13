class AddApplicationDetailsAndFurtherDetailsToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :application_details, :text
    add_column :jobs, :description_long, :text
    add_column :jobs, :responsibilities, :text
    add_column :jobs, :requirements, :text
    add_column :jobs, :benefits, :text
    add_column :jobs, :application_process, :text
  end
end
