class AddLiveToJob < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :live, :boolean, default: false
  end
end
