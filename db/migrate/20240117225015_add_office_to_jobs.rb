class AddOfficeToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :office, :string
  end
end
