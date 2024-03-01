require 'rails_helper'

RSpec.feature "Jobs", type: :feature do
  puts Rails.env
  context "With jobs present" do
    before do
      create(:job, job_title: "Software Developer")
      create(:job, job_title: "Data Analyst")
    end

    scenario "Displays jobs" do
      # arghh why isn't this working?!
      visit jobs_path

      expect(page).to have_content("Software Developer")
      expect(page).to have_content("Data Analyst")
    end
  end

  context "Without jobs" do
    scenario "Alerts no entries found" do
      visit jobs_path

      expect(page).to have_content("No entries found")
    end
  end
end
