module Ats
  module Greenhouse
    module SubmitApplication
      def submit_application
        session = Capybara::Session.new(:selenium)
        p "Created new session #{session}"

        begin
          p "Visiting #{@url}"
          session.visit(@url)
          p "Successfully reached #{@url}"
          find_apply_button(session).click

          @fields.each do |field|
            field = field[1]
            handle_field_interaction(session, field)
          end

          find_submit_button(session).click

          timeout = 10
          start_time = Time.now

          while Time.now - start_time < timeout

            if session.current_url.include?('confirmation')
              success = true
              @job_application.update(status: 'Applied')
              p "Form submitted successfully"
              break
            else
              sleep(1)
            end
          end

          unless success
            success = false
            @job_application.update(status: 'Submission failed')
            p "Form submission failed"
          end

          @fields.each do |field|
            field[1]
            if field[0] == 'resume'
              file_path = Rails.root.join('tmp', "Resume - #{@user.user_detail.first_name} #{@user.user_detail.last_name} - - #{@job.title} - #{@job.company.name}.pdf")
              FileUtils.rm_f(file_path)
            elsif field[0] == 'cover_letter_'
              file_path = Rails.root.join('tmp', "Cover Letter - #{@job.title} - #{@job.company.name} - #{@user.user_detail.first_name} #{@user.user_detail.last_name}.docx")
              FileUtils.rm_f(file_path)
            end
          end
        rescue StandardError => e
          p "Error: #{e}"
          success = false
          @job_application.update(status: 'Submission failed')
        ensure
          # take_screenshot_and_store(session, @job_application)
          session.driver.quit
        end
        p "Success: #{success}"
        success
      end

      def handle_field_interaction(session, field)
        case field['interaction']
        when 'input'
          begin
            session.fill_in(field['locators'], with: field['value'])
          rescue Capybara::ElementNotFound
            begin
              session.find(field['locators']).set(field['value'])
            rescue StandardError
              nil
            end
          end
        when 'combobox'
          begin
            select_option_from_combobox(session, field['locators'], field['option'], field['value'])
          rescue Capybara::ElementNotFound
            @errors = true
          end
        when 'radiogroup'
          begin
            select_option_from_radiogroup(session, field['locators'], field['option'], field['value'])
          rescue Capybara::ElementNotFound
            @errors = true
          end
        when 'listbox'
          begin
            select_option_from_listbox(session, field['locators'])
          rescue NoMethodError
            @errors = true
          end
        when 'select'
          begin
            select_option_from_select(session, field['locators'], field['option'], field['value'])
          rescue Capybara::ElementNotFound
            @errors = true
          end
        when 'checkbox'
          begin
            select_options_from_checkbox(session, field['locators'], field['value'])
          rescue Capybara::ElementNotFound
            @errors = true
          end
        when 'upload'
          begin
            upload_file(session, field['locators'], field['value']) unless field['value'] == ''
          rescue Capybara::ElementNotFound
            @errors = true
          end
        end
      end

      def find_apply_button(session)
        session.find(:xpath,
                     "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
      end

      def find_submit_button(session)
        session.find(:xpath,
                     "//button[contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'submit')] | //input[contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'submit')]")
      end

      def select_option_from_combobox(session, combobox_locator, option_locator, option_text)
        session.find(combobox_locator).click
        session.all(option_locator, text: option_text, visible: true)[0].click
      end

      def select_option_from_radiogroup(session, radiogroup_locator, option_locator, option_text)
        session.within(radiogroup_locator) do
          session.find(option_locator, text: option_text).click
        end
      end

      def select_option_from_listbox(session, listbox_locator)
        session.all("#{listbox_locator} li")[0].click
      end

      def select_option_from_select(session, listbox_locator, option_locator, option_text)
        session.within "##{listbox_locator}" do
          session.find(option_locator, text: option_text).click
        end
      rescue Selenium::WebDriver::Error::ElementNotInteractableError, Selenium::WebDriver::Error::JavascriptError
        new_locator = session.find("label ##{listbox_locator}")
        new_locator.ancestor("label").find("a").click
        session.find("li", text: option_text).click
      end

      def select_options_from_checkbox(session, checkbox_locator, option_text)
        option_text = JSON.parse(option_text)
        begin
          session.within('label', text: checkbox_locator) do
            option_text.each do |option|
              session.check(option)
            rescue Capybara::ElementNotFound
            end
          end
        rescue Capybara::ElementNotFound
          session.within(:xpath, "//div[contains(text(), '#{checkbox_locator}')]") do
            option_text.each do |option|
              session.check(option)
            rescue Capybara::ElementNotFound
            end
          end
          @errors = true
        end
      end

      def upload_file(session, upload_locator, file)
        # NB. Changed this from previous URI.open due to security issue - noting in case this breaks functionality (CC)
        if file.instance_of?(String)
          docx = Htmltoword::Document.create(file)
          file_path = Rails.root.join("tmp", "Cover Letter - #{@job.title} - #{@job.company.name} - #{@user.user_detail.first_name} #{@user.user_detail.last_name}.docx")
          File.binwrite(file_path, docx)
        else
          uri = URI.parse(file.url)

          raise "Invalid URL scheme" unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

          response = Net::HTTP.get_response(uri)

          raise "Failed to download file: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

          file_path = Rails.root.join("tmp", "Resume - #{@user.user_detail.first_name} #{@user.user_detail.last_name} - #{@job.title} - #{@job.company.name}.pdf")
          File.binwrite(file_path, response.body)
        end

        begin
          session.find(upload_locator).attach_file(file_path)
        rescue Capybara::ElementNotFound
          session.attach_file(file_path) do
            session.find(upload_locator).click
          end
        end
      end
    end
  end
end
