require_relative '../support/test_helpers'

include TestHelpers

# This test is designed to be run manually from a rake task.
# Tests the end-to-end process of job creation -> user application.
# Testing here means visual confirmation. It will not provide its own metrics.
# Takes one required argument, a posting_url, which is supplied from rake task via ENV.
# Takes one optional argument indicating the number of seconds to pause after
# completing Cheddar form to allow for manual review. Default pause is 0.
# It does the following:
# - creates a job, user and job_application in the test db
# - navigates to the application process page in a non-headless browser
# - fills all form fields with random values
# - submits the job application to FormFiller
RSpec.feature 'ApplyToJob', type: :feature, apply_to_job: true do
  before do
    skip 'No URL available to test' if ENV['URL_FOR_TESTING'].nil?
    @sleep_time = ENV['SLEEP_TIME'].to_i || 0

    # switch to visible browser for this test
    @original_driver = Capybara.current_driver
    Capybara.current_driver = :selenium_chrome

    job_id = initialize_job(ENV['URL_FOR_TESTING'])
    @user, @application_process, @job_application = initialize_user_and_job_application(job_id)
  end

  after(:all) do
    Capybara.current_driver = @original_driver # restore original driver
  end

  scenario "User applies to a job" do
    login_as(@user)
    visit edit_application_process_job_application_path(@application_process, @job_application)

    complete_all_fields
    pause_for_review
    submit_form

    expect(true).to be_truthy
  end
end
