require 'open-uri'

class FormFillerTest
  include Capybara::DSL

  # TODO: Review code for inefficient loops and potential optimisations
  # TODO: Add ruby monitoring tools to monitor performance and execution
  # TODO: Implement caching for both user and form inputs. At the moment we request the database every time we want an input
  # TODO: Cache values at beginning of session and then update cache when user changes values
  # TODO: Enable multi-job application support in form_filler and cache before all applications are submitted
  # TODO: Restrict search to certain portions of the page

  # Could we implement caching for form inputs? So once you've done it once it becomes less intensive

  def initialize
    @url = "https://boards.greenhouse.io/janestreet/jobs/4274809002"
    @fields = {
      first_name: {
        interaction: :input,
        locators: 'first_name',
        value: "John"
      },
      last_name: {
        interaction: :input,
        locators: 'last_name',
        value: "Doe"
      },
      email: {
        interaction: :input,
        locators: 'email',
        value: "johndoe@example.com"
      },
      phone: {
        interaction: :input,
        locators: 'phone',
        value: "+1234567890"
      },
      resume: {
        interaction: :upload,
        locators: '#resume_fieldset input[type="file"]',
        value: "path_to_resume_file"
      },
      cover_letter: {
        interaction: :upload,
        locators: '#cover_letter_fieldset input[type="file"]',
        value: "path_to_cover_letter_file"
      },
      how_did_you_hear_about_us: {
        interaction: :select,
        locators: 'select[name="job_application[answers_attributes][0][answer_selected_options_attributes][0][question_option_id]"]',
        option: 'option', # Modify as needed
        value: "54422840002" # Example value for "3Blue1Brown"
      },
      interviewed_before: {
        interaction: :select,
        locators: 'select[name="job_application[answers_attributes][2][boolean_value]"]',
        option: 'option', # Modify as needed
        value: "0" # Example value for "No"
      },
      current_student: {
        interaction: :select,
        locators: 'select[name="job_application[answers_attributes][4][boolean_value]"]',
        option: 'option', # Modify as needed
        value: "1" # Example value for "Yes"
      },
      expected_education_completion_year: {
        interaction: :select,
        locators: 'select[name="job_application[answers_attributes][8][answer_selected_options_attributes][8][question_option_id]"]',
        option: 'option', # Modify as needed
        value: "54422881002" # Example value for "2023"
      },
      current_education_level: {
        interaction: :select,
        locators: 'select[name="job_application[answers_attributes][15][answer_selected_options_attributes][15][question_option_id]"]',
        option: 'option', # Modify as needed
        value: "99507850002" # Example value for "Undergraduate"
      },
      linkedin_profile: {
        interaction: :input,
        locators: 'input[name="job_application[answers_attributes][17][text_value]"]',
        value: "https://www.linkedin.com/in/johndoe"
      }
    }
  end

  def fill_out_form
    # SETUP Capybara
    @errors = nil
    visit(@url)
    find_apply_button.click rescue nil

    @fields.each do |field|
      field = field[1]
      case field[:interaction]
      when :input
        begin
          p field[:locators]
          fill_in(field[:locators], with: field[:value])
        rescue Capybara::ElementNotFound
          p "Field locator #{field[:locators]} is not found"
          find(field[:locators]).set(field[:value]) rescue nil
        end
      when :combobox
        begin
          select_option_from_combobox(field[:locators], field[:option], field[:value])
        rescue Capybara::ElementNotFound
          p "Field locator #{field[:locators]} is not found"
          @errors = true
        end
      when :radiogroup
        begin
          select_option_from_radiogroup(field[:locators], field[:option], field[:value])
        rescue Capybara::ElementNotFound
          p "Field locator #{field[:locators]} is not found"
          @errors = true
        end
      when :listbox
        begin
          select_option_from_listbox(field[:locators])
        rescue NoMethodError
          p "Field locator #{field[:locators]} is not found"
          @errors = true
        end
      when :select
        begin
          select_option_from_select(field[:locators], field[:option], field[:value])
        rescue Capybara::ElementNotFound
          p "Field locator #{field[:locators]} is not found"
          @errors = true
        end
      end

    end
    # Return a screenshot of the submitted form
    # take_screenshot_and_store(job_application_id)
    # close_session(job_application_id)
    @fields.each do |field|
      field = field[1]
      if field['interaction'] == 'upload'
        file_path = Rails.root.join('tmp', "#{field['value'].filename}")
        File.delete(file_path) if File.exists?(file_path)
      end
    end
  end

  private

  def close_session(job_application_id)
    # take_screenshot_and_store(job_application_id)
    Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  end

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end

  def select_option_from_combobox(combobox_locator, option_locator, option_text)
    find(combobox_locator).click
    all(option_locator, text: option_text, visible: true)[0].click
  end

  def select_option_from_radiogroup(radiogroup_locator, option_locator, option_text)
    within(radiogroup_locator) do
      find(option_locator, text: option_text).click
    end
  end

  def select_option_from_listbox(listbox_locator)
    all("#{listbox_locator} li")[0].click
  end

  def select_option_from_select(listbox_locator, option_locator, option_text)
    begin
      within listbox_locator do
        find(option_locator, text: option_text).click
      end
    rescue Selenium::WebDriver::Error::ElementNotInteractableError
      p 'cannot interact with hidden element'
      p listbox_locator
      new_locator = page.find("label #{listbox_locator}")
      p new_locator
      new_locator.ancestor("label").find("a").click
      find("div.select2-drop li", text: option_text).click
    end
  end

  def upload_file(upload_locator, file)
    file_path = Rails.root.join('tmp', "#{file.filename}")
    File.open(file_path, 'wb') do |temp_file|
      temp_file.write(URI.open(file.url).read)
    end
    begin
      find(upload_locator).attach_file(file_path)
    rescue Capybara::ElementNotFound
      page.attach_file(file_path) do
        page.find(upload_locator).click
      end
    end
    # File.delete(file_path)
  end

  # TODO: Decide whether to include screenshot. Auto-email from the company may be sufficient evidence
  # TODO: Check whether new screenshot method works

  # ------------
  # New method for taking screenshots - saves screenshot in memory rather than to disk
  # ------------

  def take_screenshot_and_store(job_application_id)
    screenshot_path = Rails.root.join('tmp', "screenshot-#{job_application_id}.png")
    page.save_screenshot(screenshot_path, full: true)

    # Store the screenshot using Active Storage
    file = File.open(screenshot_path)
    job_app = JobApplication.find(job_application_id) # Replace with your actual job_app using the id from the initialize method
    job_app.screenshot.attach(io: file, filename: "screenshot-#{job_application_id}.png", content_type: 'image/png')

    # Clean up temporary screenshot file
    File.delete(screenshot_path)
  end
end
