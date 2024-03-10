require 'rails_helper'

RSpec.feature "Jobs", type: :feature do
  # context "With jobs to display:" do
  #   before do
  #     london = create(:location, city: "London")

  #     create(:job, job_title: "Graduate Software Developer", seniority: 'Entry-Level', role: 'mobile')
  #     create(:job, job_title: "Junior Test Developer", seniority: 'Junior', role: 'dev_ops')
  #     create(:job, job_title: "Data Analyst", seniority: 'Mid-Level', role: 'data_engineer')
  #     job1 = create(:job, job_title: "Senior UI Engineer", seniority: 'Senior', role: 'front_end')
  #     job2 = create(:job, job_title: "Frontend Developer", job_description: "Ruby on Rails", role: 'front_end')
  #     job3 = create(:job, job_title: "Ruby on Rails Developer")

  #     create(:jobs_location, job: job1, location: london)
  #     create(:jobs_location, job: job2, location: london)
  #     create(:jobs_location, job: job3, location: london)

  #     visit jobs_path
  #   end

  #   scenario "Displays all jobs" do
  #     expect(page).to have_content("Graduate Software Developer")
  #     expect(page).to have_content("Data Analyst")
  #     expect(page).to have_content("Senior UI Engineer")
  #     expect(page).to have_content("#{Job.all.count} jobs")
  #   end

  #   # scenario "User can select three jobs" do
  #   #   all('.custom-checkbox').take(3).each do |checkbox|
  #   #     checkbox.click
  #   #   end

  #   #   all('.select-job-box').take(3).each do |checkbox|
  #   #     expect(checkbox).to be_checked
  #   #   end

  #   #   expect(page).to have_button("Shortlist 3 Job")
  #   # end

  #   # scenario "User can deselect two of them" do
  #   #   all('.custom-checkbox').take(3).each do |checkbox|
  #   #     checkbox.click
  #   #   end

  #   #   all('.custom-checkbox').take(2).each do |checkbox|
  #   #     checkbox.click
  #   #   end

  #   #   expect(all('.select-job-box')[2]).to be_checked
  #   #   expect(all('.select-job-box')[1]).to_not be_checked

  #   #   expect(page).to have_button("Shortlist 1 Job")
  #   # end

  #   scenario 'User can query "Ruby on Rails London" jobs' do
  #     fill_in 'query', with: 'ruby on rails london'
  #     find('#search-button').click

  #     expect(page).to have_content("Frontend Developer")
  #     expect(page).to have_content("Ruby on Rails Developer")

  #     expect(page).not_to have_content("Senior UI Engineer")
  #   end

  #   scenario "User can filter jobs by seniority" do
  #     check('entry-level')
  #     check('mid-level')
  #     check('senior')

  #     expect(page).to have_content("Graduate Software Developer")
  #     expect(page).to have_content("Data Analyst")
  #     expect(page).to have_content("Senior UI Engineer")

  #     expect(page).not_to have_content("Junior Test Developer")
  #   end

  #   scenario "User can filter jobs by location" do
  #     check('london')

  #     expect(page).to have_content("#{Job.joins(jobs_locations: :location).where(locations: { city: 'London' }).count} jobs")
  #   end

  #   scenario "User can filter jobs by role" do
  #     check('front_end')
  #     check('data_engineer')

  #     expect(page).to have_content("Senior UI Engineer")
  #     expect(page).to have_content("Data Analyst")

  #     expect(page).not_to have_content("Junior Test Developer")
  #   end

  #   scenario "User can filter jobs by company" do
  #     job1 = Job.first
  #     job2 = Job.where.not(company: job1.company).first
  #     company = job1.company.id.to_s

  #     check(company)

  #     expect(page).to have_content(job1.job_title)
  #     expect(page).not_to have_content(job2.job_title)
  #   end

  #   scenario 'User can query "Ruby" with multiple sidebar filters' do
  #     fill_in 'query', with: 'ruby'
  #     find('#search-button').click

  #     check('london')
  #     check('front_end')

  #     expect(page).to have_content("Frontend Developer")
  #     expect(page).not_to have_content("Ruby on Rails Developer")
  #   end
  # end

  # context "With multiple pages of jobs to display:" do
  #   before do
  #     create_list(:job, 50, seniority: 'Senior')

  #     visit jobs_path(seniority: 'Senior')
  #   end

  #   scenario "User can visit the next page of job postings" do
  #     jobs_per_page = find('body').text.match(/Displaying Jobs? \d+ - (\d+) of \d+/i)[1].to_i
  #     job1 = Job.all[jobs_per_page - 1]
  #     job2 = Job.all[jobs_per_page + 1]

  #     find('a[aria-label="Page 2"]').click

  #     expect(page).to have_content(job2.job_title)
  #     expect(page).not_to have_content(job1.job_title)
  #   end
  # end

  # context "With no jobs to display:" do
  #   scenario "Indicates \"No entries found\"" do
  #     visit jobs_path

  #     expect(page).to have_content("No entries found")
  #   end
  # end

  # context "With a user logged in:" do
  #   before do
  #     user = create(:user)
  #     create_list(:job, 5)

  #     login_as(user, scope: :user)
  #     visit jobs_path
  #   end

  #   scenario "User can save and unsave jobs by clicking the bookmark icon" do
  #     2.times do
  #       all('i.fa-regular.fa-bookmark').first.click
  #       sleep 1
  #     end

  #     expect(SavedJob.all.count).to eq(2)

  #     all('i.fa-solid.fa-bookmark').first.click
  #     sleep 1

  #     expect(SavedJob.all.count).to eq(1)
  #   end
  # end
end
