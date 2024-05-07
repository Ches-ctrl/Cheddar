class AddFieldLabelToApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :application_responses, :field_label, :string
  end
end
