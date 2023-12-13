class AddNameToAtsFormat < ActiveRecord::Migration[7.1]
  def change
    add_column :ats_formats, :name, :string
  end
end
