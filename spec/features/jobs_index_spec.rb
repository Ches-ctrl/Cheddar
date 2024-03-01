require 'rails_helper'

RSpec.feature "Jobs", type: :feature do
  context "With jobs present" do
    before do
      create(:job, job_title: "Graduate Software Developer")
      create(:job, job_title: "Data Analyst")
      create(:job, job_title: "Senior UI Engineer")
      # create 20 more jobs
      20.times do
        create(:job)
      end
    end

    scenario "Displays all jobs" do
      visit jobs_path

      expect(page).to have_content("Graduate Software Developer")
      expect(page).to have_content("Data Analyst")
      expect(page).to have_content("Senior UI Engineer")
      expect(page).to have_content("#{Job.all.count} Jobs")
    end
  end

  context "Without jobs" do
    scenario "Alerts no entries found" do
      visit jobs_path

      expect(page).to have_content("No entries found")
    end
  end
end
