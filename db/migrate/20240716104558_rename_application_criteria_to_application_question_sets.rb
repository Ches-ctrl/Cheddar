# frozen_string_literal: true

class RenameApplicationCriteriaToApplicationQuestionSets < ActiveRecord::Migration[7.1]
  def change
    rename_table :application_criteria, :application_question_sets
  end
end
