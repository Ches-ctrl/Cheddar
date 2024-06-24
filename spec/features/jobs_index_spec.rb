# require 'ruby-prof'

# rubocop:disable Metrics/BlockLength
# RSpec.feature "Jobs index page", type: :feature, jobs_index: true do
#   context "With jobs to display:", type: :feature, jobs_display: true do
#     before do
#       # RubyProf.start
#       # TODO: This is still taking up a lot of time - refactor this to be more efficient
#       @jobs = [
#         { trait: :entry_level_mobile, title: "Graduate Software Developer" },
#         { trait: :junior_dev_ops, title: "Junior Test Developer" },
#         { trait: :mid_level_data, title: "Data Analyst" },
#         { trait: :senior_front_end, trait2: :in_london, title: "Senior UI Engineer" },
#         { trait: :ruby_front_end, trait2: :in_london, title: "Frontend Developer" },
#         { trait: nil, trait2: :in_london, title: "Ruby on Rails Developer" }
#       ]

#       @jobs.each do |job|
#         traits = [job[:trait], job[:trait2]].compact
#         create(:job, *traits, title: job[:title])
#       end
#       # result = RubyProf.stop

#       # printer = RubyProf::GraphHtmlPrinter.new(result)
#       # File.open("profile.html", "w") do |file|
#       #   printer.print(file)
#       # end
#       visit jobs_path
#     end

#     scenario "Displays all jobs" do
#       expect(page).to have_content("Graduate Software Developer")
#       expect(page).to have_content("#{@jobs.size} jobs")
#     end

#     scenario 'User can query "Ruby on Rails" jobs' do
#       fill_in 'query', with: 'ruby on rails'
#       find('#search-button').click

#       expect(page).to have_content("Frontend Developer")
#       expect(page).not_to have_content("Senior UI Engineer")
#     end

#     scenario "User can filter jobs by seniority" do
#       check('entry-level')
#       # check('mid-level')

#       expect(page).to have_content("Graduate Software Developer")
#       expect(page).not_to have_content("Junior Test Developer")
#     end

#     scenario "User can filter jobs by location" do
#       check('london')

#       expect(page).to have_content("#{Job.joins(jobs_locations: :location).where(locations: { city: 'London' }).count} jobs")
#     end

#     scenario "User can filter jobs by role" do
#       check('front_end')
#       # check('data_engineer')

#       expect(page).to have_content("Senior UI Engineer")
#       expect(page).not_to have_content("Junior Test Developer")
#     end

#     scenario 'User can query "Ruby" with multiple sidebar filters' do
#       fill_in 'query', with: 'ruby'
#       find('#search-button').click

#       check('london')
#       check('front_end')

#       expect(page).to have_content("Frontend Developer")
#       expect(page).not_to have_content("Ruby on Rails Developer")
#     end
#   end

#   context "With multiple pages of jobs to display:" do
#     before do
#       create_list(:job, 11, seniority: 'Senior')
#       visit jobs_path(seniority: 'Senior')
#     end

#     # scenario "User can visit the next page of job postings" do
#     #   jobs_per_page = 10
#     #   # job1 = Job.all[jobs_per_page - 1]
#     #   job2 = Job.all[jobs_per_page + 1]

#     #   find('a[rel="next"]', text: '2').click

#     #   expect(page).to have_content(job2.title)
#     #   # expect(page).not_to have_content(job1.title)
#     # end
#   end

#   context "With no jobs to display:" do
#     scenario "Indicates \"No entries found\"" do
#       visit jobs_path

#       expect(page).to have_content("No jobs found")
#     end
#   end

#   context "With a user logged in:", type: :feature, logged_in: true do
#     before do
#       user = create(:user)
#       create_list(:job, 5)

#       login_as(user, scope: :user)
#       visit jobs_path
#     end

#     scenario "User can save and unsave jobs by clicking the bookmark icon" do
#       2.times do
#         all('i.fa-regular.fa-bookmark').first.click
#         sleep(0.5)
#       end

#       expect(SavedJob.all.count).to eq(2)

#       all('i.fa-solid.fa-bookmark').first.click
#       sleep(0.5)

#       expect(SavedJob.all.count).to eq(1)
#     end
#   end

#   context "Without a user logged in:", type: :feature, logged_out: true do
#     before do
#       create_list(:job, 5)
#       visit jobs_path
#     end

#     scenario "User cannot save and unsave jobs without logging in" do
#       expect(page).not_to have_selector('i.fa-regular.fa-bookmark')
#       expect(SavedJob.all.count).to eq(0)
#     end
#   end
# end
# rubocop:enable Metrics/BlockLength
