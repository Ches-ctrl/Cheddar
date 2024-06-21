# frozen_string_literal: true

class CreateApplicationProcesses < ActiveRecord::Migration[7.1]
  def change
    create_table :application_processes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "new"
      t.jsonb :frequent_asked_info, null: false, default: {}
      t.timestamps
      t.datetime :submitted_at, null: true
    end
  end
end
