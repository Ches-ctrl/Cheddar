# frozen_string_literal: true

class AddJobsCountJobLastUpdatedAtOptinToSavedSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :saved_searches, :jobs_count, :integer
    add_column :saved_searches, :job_last_updated_at, :datetime
    add_column :saved_searches, :optin, :boolean, default: false
  end
end
