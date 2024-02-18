class AddRequiredToApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :application_responses, :required, :boolean
  end
end
