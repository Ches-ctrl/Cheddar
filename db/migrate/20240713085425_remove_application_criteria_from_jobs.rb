# frozen_string_literal: true

class RemoveApplicationCriteriaFromJobs < ActiveRecord::Migration[7.1]
  def change
    remove_column :jobs, :application_criteria
  end
end
