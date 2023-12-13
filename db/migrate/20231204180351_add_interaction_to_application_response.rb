class AddInteractionToApplicationResponse < ActiveRecord::Migration[7.1]
  def change
    add_column :application_responses, :interaction, :string
  end
end
