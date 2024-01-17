class DeleteAtsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :ats_formats
  end
end
