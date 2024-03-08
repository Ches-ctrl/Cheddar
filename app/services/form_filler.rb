require 'open-uri'
require 'json'
require 'htmltoword'

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
    @job_application = JobApplication.find_by_id(job_application_id)
    @user = @job_application.user
    @job = @job_application.job
    @errors = nil

    visit(url)
    find_apply_button.click rescue nil

    fields.each do |field|
      field = field[1]
      case field['interaction']
      when 'input'
        begin
          fill_in(field['locators'], with: field['value'])
        rescue Capybara::ElementNotFound
          find(field['locators']).set(field['value']) rescue nil
        end
      when 'combobox'
        begin
          select_option_from_combobox(field['locators'], field['option'], field['value'])
        rescue Capybara::ElementNotFound
          @errors = true
        end
      when 'radiogroup'
        begin
          select_option_from_radiogroup(field['locators'], field['option'], field['value'])
        rescue Capybara::ElementNotFound
          @errors = true
        end
      when 'listbox'
        begin
          select_option_from_listbox(field['locators'])
        rescue NoMethodError
          @errors = true
        end
      when 'select'
        begin
          select_option_from_select(field['locators'], field['option'], field['value'])
        rescue Capybara::ElementNotFound
          @errors = true
        end
      when 'checkbox'
        begin
          select_options_from_checkbox(field['locators'], field['value'])
        rescue Capybara::ElementNotFound
          @errors = true
        end
      when 'upload'
        begin
          unless field['value'] == ''
            upload_file(field['locators'], field['value'])
          end
        rescue Capybara::ElementNotFound
          @errors = true
        end
      end
    end
    # TODO: Add check on whether form has been submitted successfully
    # submit = find_submit_button.click rescue nil
    take_screenshot_and_store(job_application_id)
    close_session(job_application_id)

    fields.each do |field|
      attribute = field[1]
      if field[0] == 'resume'
        file_path = Rails.root.join('tmp', "Cover Letter - #{@user.first_name} #{@user.last_name}.pdf")
        File.delete(file_path) if File.exists?(file_path)
      elsif field[0] == 'cover_letter_'
        file_path = Rails.root.join('tmp', "Cover Letter - #{@job.job_title} - #{@job.company.company_name} - #{@user.first_name} #{@user.last_name}.docx")
        File.delete(file_path) if File.exists?(file_path)
      end
    end

    @job_application.update(status: 'Applied')
  end


  private

  def close_session(job_application_id)
    Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  end

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end

  def find_submit_button
    find(:xpath, "//button[contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'submit')] | //input[contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'submit')]")
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
      within "##{listbox_locator}" do
        find(option_locator, text: option_text).click
      end
    rescue Selenium::WebDriver::Error::ElementNotInteractableError
      new_locator = page.find("label ##{listbox_locator}")
      new_locator.ancestor("label").find("a").click
      find("li", text: option_text).click
    end
  end

  def select_options_from_checkbox(checkbox_locator, option_text)
    option_text = JSON.parse(option_text)
    begin
      within('label', text: checkbox_locator) do
        option_text.each do |option|
          begin
            check(option)
          rescue Capybara::ElementNotFound
          end
        end
      end
    rescue Capybara::ElementNotFound
      within(:xpath, "//div[contains(text(), '#{checkbox_locator}')]") do
        option_text.each do |option|
          begin
            check(option)
          rescue Capybara::ElementNotFound
          end
        end
      end
      @errors = true
    end
  end

  def upload_file(upload_locator, file)
    if file.instance_of?(String)
      docx = Htmltoword::Document.create(file)
      file_path = Rails.root.join('tmp', "Cover Letter - #{@job.job_title} - #{@job.company.company_name} - #{@user.first_name} #{@user.last_name}.docx")
      File.open(file_path, 'wb') do |temp_file|
        temp_file.write(docx)
      end
    else
      file_path = Rails.root.join('tmp', "Resume - #{@user.first_name} #{@user.last_name}.pdf")
      File.open(file_path, 'wb') do |temp_file|
        temp_file.write(URI.open(file.url).read)
      end
    end
    begin
      find(upload_locator).attach_file(file_path)
    rescue Capybara::ElementNotFound
      page.attach_file(file_path) do
        page.find(upload_locator).click
      end
    end
  end

  def take_screenshot_and_store(job_application_id)
    screenshot_path = Rails.root.join('tmp', "screenshot-#{job_application_id}.png")
    page.save_screenshot(screenshot_path, full: true)

    file = File.open(screenshot_path)
    job_app = JobApplication.find(job_application_id)
    job_app.screenshot.attach(io: file, filename: "screenshot-#{job_application_id}.png", content_type: 'image/png')

    File.delete(screenshot_path)
  end
end
