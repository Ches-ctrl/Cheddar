class AddCoreFieldToApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :application_responses, :core_field, :boolean
  end
end
