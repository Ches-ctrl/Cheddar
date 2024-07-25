class ChangeDefaultValuesForStatusOnApplicationProcesses < ActiveRecord::Migration[7.1]
  def change
    change_column_default :application_processes, :status, "initial"
  end
end
