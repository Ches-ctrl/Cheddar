class RemoveCoverLetterContentFromApplicationResponses < ActiveRecord::Migration[7.1]
  def change
    remove_column :application_responses, :cover_letter_content
  end
end
