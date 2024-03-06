class RemoveDefaultFromApplicationDeadlineInJobs < ActiveRecord::Migration[7.1]
  def up
    change_column_default :jobs, :application_deadline, nil
  end

  def down
    change_column_default :jobs, :application_deadline, "2024-01-22"
  end
end
