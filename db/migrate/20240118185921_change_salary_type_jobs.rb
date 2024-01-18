class ChangeSalaryTypeJobs < ActiveRecord::Migration[7.1]
  def change
    change_column :jobs, :salary, :string
  end
end
