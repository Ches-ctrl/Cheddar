class AddColumnToApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :application_responses, :field_options, :string
  end
end
