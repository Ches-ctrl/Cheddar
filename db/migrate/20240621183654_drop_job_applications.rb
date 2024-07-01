# frozen_string_literal: true

class DropJobApplications < ActiveRecord::Migration[7.1]
  def change
    drop_table :application_responses
    drop_table :job_applications
  end
end
