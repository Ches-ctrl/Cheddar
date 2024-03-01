require 'rails_helper'

RSpec.feature "Jobs", type: :feature do
  context "With jobs to display:" do
    before do
      create(:job, job_title: "Graduate Software Developer", seniority: 'Entry-Level', role: 'mobile')
      create(:job, job_title: "Junior Test Developer", seniority: 'Junior', role: 'dev_ops')
      create(:job, job_title: "Data Analyst", seniority: 'Mid-Level', role: 'data_engineer')
      create(:job, job_title: "Senior UI Engineer", seniority: 'Senior', role: 'front_end')

      # create 20 more jobs in London
      20.times do
        create(:job, location: "London, UK")
      end
    end

    scenario "Displays all jobs" do
      visit jobs_path

      expect(page).to have_content("Graduate Software Developer")
      expect(page).to have_content("Data Analyst")
      expect(page).to have_content("Senior UI Engineer")
      expect(page).to have_content("#{Job.all.count} Jobs")
    end

    scenario "User can filter jobs by seniority" do
      visit jobs_path(seniority: 'entry-level mid-level senior')

      expect(page).to have_content("Graduate Software Developer")
      expect(page).to have_content("Data Analyst")
      expect(page).to have_content("Senior UI Engineer")

      expect(page).not_to have_content("Junior Test Developer")
    end

    scenario "User can filter jobs by location" do
      visit jobs_path(location: 'london')

      expect(page).to have_content("#{Job.where(city: 'London').count} Jobs")
    end

    scenario "User can filter jobs by role" do
      visit jobs_path(role: 'front_end data_engineer')

      expect(page).to have_content("Senior UI Engineer")
      expect(page).to have_content("Data Analyst")

      expect(page).not_to have_content("Junior Test Developer")
    end

    scenario "User can filter jobs by company" do
      job1 = Job.first
      job2 = Job.where.not(company: job1.company).first
      company = job1.company.id.to_s
      visit jobs_path(company: company)

      expect(page).to have_content(job1.job_title)

      expect(page).not_to have_content(job2.job_title)
    end
  end

  context "With no jobs to display:" do
    scenario "Indicates \"No entries found\"" do
      visit jobs_path

      expect(page).to have_content("No entries found")
    end
  end
end
