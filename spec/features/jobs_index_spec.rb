require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature "Jobs index page", type: :feature, jobs_index: true do
  context "With jobs to display:" do
    before do
      create(:job, :entry_level_mobile, title: "Graduate Software Developer")
      create(:job, :junior_dev_ops, title: "Junior Test Developer")
      create(:job, :mid_level_data, title: "Data Analyst")
      create(:job, :senior_front_end, :in_london, title: "Senior UI Engineer")
      create(:job, :ruby_front_end, :in_london, title: "Frontend Developer")
      create(:job, :in_london, title: "Ruby on Rails Developer")
      visit jobs_path
    end

    scenario "Displays all jobs" do
      expect(page).to have_content("Graduate Software Developer")
      expect(page).to have_content("Data Analyst")
      expect(page).to have_content("Senior UI Engineer")
      expect(page).to have_content("#{Job.all.count} jobs")
    end

    scenario 'User can query "Ruby on Rails" jobs' do
      fill_in 'query', with: 'ruby on rails'
      find('#search-button').click

      expect(page).to have_content("Frontend Developer")
      expect(page).to have_content("Ruby on Rails Developer")

      expect(page).not_to have_content("Senior UI Engineer")
    end

    scenario "User can filter jobs by seniority" do
      check('entry-level')
      check('mid-level')
      check('senior')

      expect(page).to have_content("Graduate Software Developer")
      expect(page).to have_content("Data Analyst")
      expect(page).to have_content("Senior UI Engineer")

      expect(page).not_to have_content("Junior Test Developer")
    end

    scenario "User can filter jobs by location" do
      check('london')

      expect(page).to have_content("#{Job.joins(jobs_locations: :location).where(locations: { city: 'London' }).count} jobs")
    end

    scenario "User can filter jobs by role" do
      check('front_end')
      check('data_engineer')

      expect(page).to have_content("Senior UI Engineer")
      expect(page).to have_content("Data Analyst")

      expect(page).not_to have_content("Junior Test Developer")
    end

    scenario 'User can query "Ruby" with multiple sidebar filters' do
      fill_in 'query', with: 'ruby'
      find('#search-button').click

      check('london')
      check('front_end')

      expect(page).to have_content("Frontend Developer")
      expect(page).not_to have_content("Ruby on Rails Developer")
    end
  end

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

  #     expect(page).to have_content(job2.title)
  #     expect(page).not_to have_content(job1.title)
  #   end
  # end

  context "With no jobs to display:" do
    scenario "Indicates \"No entries found\"" do
      visit jobs_path

      expect(page).to have_content("No entries found")
    end
  end

  context "With a user logged in:" do
    before do
      user = create(:user)
      create_list(:job, 5)

      login_as(user, scope: :user)
      visit jobs_path
    end

    scenario "User can save and unsave jobs by clicking the bookmark icon" do
      2.times do
        all('i.fa-regular.fa-bookmark').first.click
        sleep 1
      end

      expect(SavedJob.all.count).to eq(2)

      all('i.fa-solid.fa-bookmark').first.click
      sleep 1

      expect(SavedJob.all.count).to eq(1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
