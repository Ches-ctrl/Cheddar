# frozen_string_literal: true

module Applier
  # Parent class for handling workflow of filling application forms in Capybara.
  # Initialized with payload from JobApplication.
  # Each question type has its own method, which is named #handle_[question_type].
  # Children inheriting from this class will override some of the above methods with logic specific to each ATS's form.
  # Creates a tmp file to handle file uploads. :user_fullname is required only for the purpose of naming the file that's uploaded.
  # #verify_input prevents long strings being inputted inaccurately; seems to work faster than using #send_keys to input text.
  class FormFiller < ApplicationTask
    include Capybara::DSL
    include LoggingHelper

    def initialize(payload)
      p "here's the payload:" # for testing
      p payload
      @fields = payload[:fields]
      @session = Capybara::Session.new(:selenium)
      @url = payload[:apply_url]
      @user_fullname = payload[:user_fullname]
    end

    def call
      return false unless processable

      using_session(@session) do
        process
      end
    end

    private

    def processable
      @url && @fields && @session
    end

    def process
      visit_url
      log_runtime(:fill_application_form)
      click_submit_button
      verify_submission
    ensure
      @session.quit
    end

    def application_form = '#form'

    def apply_button
      find(:css, 'button, a', text: /apply/i, match: :first, visible: true, wait: 8)
    end

    def attach_file_to_application
      attach_file(@locator, @filepath)
    end

    def boolean_field = find_by_id(@locator)

    def click_apply_button
      apply_button.click
    end

    def click_submit_button
      sleep 8 # temporary -- just for testing
      p "I didn't submit the form. Change the FormFiller#click_submit_button method to actually submit it."
      # submit_button.click
    end

    def convert_date
      date_string_from_payload = @value
      @value = Date.strptime(date_string_from_payload, '%Y-%m-%d')
                   .strftime(fetch_date_format)
    end

    # Determines the strftime format based on the form element's placeholder value
    def fetch_date_format
      format_map = {
        'mm' => '%m',
        'dd' => '%d',
        'yy' => '%y',
        'yyyy' => '%Y'
      }

      find_field(@locator)['placeholder']
        .gsub(/[mdy]+/i) { |match| format_map[match.downcase] }
    end

    def doc_tmp_file
      docx = Htmltoword::Document.create(@value)
      @filepath = Rails.root.join("tmp", "Cover Letter_#{unique_string}.docx")
      File.binwrite(@filepath, docx)
    end

    def fill_application_form
      click_apply_button
      fill_in_all_fields
    end

    def fill_in_all_fields
      within application_form do
        @fields.each { |field| fill_in_field(field) }
      end
    end

    def fill_in_field(field)
      @locator = field[:locator]
      @value = field[:value]
      send(:"handle_#{field[:interaction]}")
    rescue Capybara::ElementNotFound => e
      p e.message
    end

    def handle_boolean = (boolean_field.click if @value)

    def handle_checkbox = check(@value)

    def handle_date_picker = handle_input

    # def handle_input = verify_input { fill_in(@locator, with: @value) }
    def handle_input = find_field(@locator).send_keys(@value)

    def handle_location
      puts "Location questions not handled!"
    end

    def handle_multi_select
      within response_field do
        @value.each { |value| check(value) }
      end
    end

    def handle_radiogroup
      choose(option: @value, name: @locator)
    end

    def handle_select
      within select_menu do
        click # expand
        select_option.click
      end
    end

    def handle_upload
      url?(@value) ? pdf_tmp_file : doc_tmp_file
      attach_file_to_application
    end

    def pdf_tmp_file
      uri = URI.parse(@value)
      @value = Net::HTTP.get_response(uri).body # TODO: replace with CheckUrlIsValid#get?
      @filepath = Rails.root.join("tmp", "Resume - #{unique_string}.pdf")
      File.binwrite(@filepath, @value)
    end

    def response_field
      first('label', text: @locator)
    rescue Capybara::ElementNotFound
      first('div', text: @locator)
    end

    def select_menu = find_by_id(@locator)

    def submit_button
      first(:button, text: /submit/i) || first(:link, text: /submit/i)
    end

    def timestamp
      Time.now.to_s.truncate(19).gsub(/\D/, '')
    end

    def unique_string
      "#{@user_fullname}_#{timestamp}"
    end

    def url?(string)
      URI(string).present?
    rescue
      false
    end

    def verify_input(retries = 3)
      returned_value = yield.value
      raise Applier::IncorrectInputError unless returned_value == @value
    rescue Applier::IncorrectInputError
      retries -= 1
      retry unless retries.negative?
    end

    def verify_submission
      sleep 10 # temporary -- just for testing
      # TODO: add logic to check for successful submission message or other indicators
    end

    def visit_url
      visit(@url)
      p "Successfully reached #{@url}"
    end
  end
end
