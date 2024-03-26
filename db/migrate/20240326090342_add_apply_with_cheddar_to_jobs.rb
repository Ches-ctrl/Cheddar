class AddApplyWithCheddarToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :apply_with_cheddar, :boolean, default: false
  end
end
