class AddRequiredFieldToAtsFormat < ActiveRecord::Migration[7.1]
  def change
    add_column :ats_formats, :required, :boolean
  end
end
