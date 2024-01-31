class AddCoverLetterContentToApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :application_responses, :cover_letter_content, :text
  end
end
