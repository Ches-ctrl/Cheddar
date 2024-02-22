class AddHybridToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :hybrid, :boolean
  end
end
