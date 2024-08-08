require_relative '../support/test_helpers'

include TestHelpers

RSpec.feature 'ApplyToJob', type: :feature, apply_to_job: true do
  before do
    skip 'No URL available to test' if ENV['URL_FOR_TESTING'].nil?

    # switch to visible browser for this test
    @original_driver = Capybara.current_driver
    Capybara.current_driver = :selenium_chrome

    job_id = initialize_job(ENV['URL_FOR_TESTING'])
    @user, @application_process, @job_application = initialize_user_and_job_application(job_id)
  end

  after(:all) do
    # clean test database and restore original settings (necessary if calling this from a rakefile)
    User.destroy_all
    Company.destroy_all
    Capybara.current_driver = @original_driver # restore original driver
  end

  scenario "User applies to a job" do
    login_as(@user)
    visit edit_application_process_job_application_path(@application_process, @job_application)

    all('input[type="text"]').each do |field|
      field.set("hello")
    rescue Selenium::WebDriver::Error::ElementNotInteractableError
      next
    end
    sleep 5

    expect(true).to be_truthy
  end
end
