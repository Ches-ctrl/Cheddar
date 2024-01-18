require 'open-uri'
require 'json'

class FormFiller
  include Capybara::DSL

  # TODO: Handle job posting becoming closed (redirect or notification on page)
  # TODO: Review code for inefficient loops and potential optimisations
  # TODO: Add ruby monitoring tools to monitor performance and execution
  # TODO: Implement caching for both user and form inputs. At the moment we request the database every time we want an input
  # TODO: Cache values at beginning of session and then update cache when user changes values
  # TODO: Enable multi-job application support in form_filler and cache before all applications are submitted
  # TODO: Restrict search to certain portions of the page

  # Could we implement caching for form inputs? So once you've done it once it becomes less intensive

  def fill_out_form(url, fields, job_application_id)
    # SETUP Capybara
    @errors = nil
    visit(url)
    find_apply_button.click rescue nil

    pp fields # for testing purposes

    fields.each do |field|
      field = field[1]
      p field
      case field['interaction']
      when 'input'
        begin
          fill_in(field['locators'], with: field['value'])
        rescue Capybara::ElementNotFound
          p "Field locator #{field['locators']} is not found"
          find(field['locators']).set(field['value']) rescue nil
        end
      when 'combobox'
        begin
          select_option_from_combobox(field['locators'], field['option'], field['value'])
        rescue Capybara::ElementNotFound
          p "Field locator #{field['locators']} is not found"
          @errors = true
        end
      when 'radiogroup'
        begin
          select_option_from_radiogroup(field['locators'], field['option'], field['value'])
        rescue Capybara::ElementNotFound
          p "Field locator #{field['locators']} is not found"
          @errors = true
        end
      when 'listbox'
        begin
          select_option_from_listbox(field['locators'])
        rescue NoMethodError
          p "Field locator #{field['locators']} is not found"
          @errors = true
        end
      when 'select'
        begin
          select_option_from_select(field['locators'], field['option'], field['value'])
        rescue Capybara::ElementNotFound
          p "Field locator #{field['locators']} is not found"
          @errors = true
        end
      when 'checkbox'
        begin
          select_options_from_checkbox(field['locators'], field['value'])
        rescue Capybara::ElementNotFound
          p "Field locator #{field['locators']} is not found"
          @errors = true
        end
      when 'upload'
        begin
          upload_file(field['locators'], field['value'])
        rescue Capybara::ElementNotFound
          p "Field locator #{field['locators']} is not found"
          @errors = true
        end
      end

    end

    # TODO: Add submit form capability to the FormFiller
    # TODO: Add check on whether form has been submitted successfully

    # Return a screenshot of the submitted form
    take_screenshot_and_store(job_application_id)
    close_session(job_application_id)
    fields.each do |field|
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
      p "Printing some info for testing..."
      p listbox_locator, option_locator, option_text
      within "##{listbox_locator}" do
        find(option_locator, text: option_text).click
      end
      p "checkpoint"
    rescue Selenium::WebDriver::Error::ElementNotInteractableError
      p 'cannot interact with hidden element'
      p listbox_locator
      new_locator = page.find("label ##{listbox_locator}")
      p new_locator
      new_locator.ancestor("label").find("a").click
      p "Select box clicked"
      find("li", text: option_text).click
      p "checkpoint two"
    end
  end

  def select_options_from_checkbox(checkbox_locator, option_text)
    p checkbox_locator, option_text
    option_text = JSON.parse(option_text)
    # option_text.shift
    within('label', text: checkbox_locator) do
      p "I am within the #{checkbox_locator} checkbox"
      option_text.each do |option|
        begin
          check(option)
        rescue Capybara::ElementNotFound
          p "Unable to check #{option}"
        end
      end
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

  # TODO: Update screenshot to bypass need for save

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
