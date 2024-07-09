# frozen_string_literal: true

module Applier
  class FormFiller < ApplicationTask
    include Capybara::DSL
    def initialize(payload)
      @application_form = payload[:form_locator]
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
      fill_application_form
      click_submit_button
      verify_submission
    ensure
      @session.quit
    end

    def apply_button
      first(:button, text: /apply/i) || first(:link, text: /apply/i)
    end

    def attach_file_to_application(filepath, locator)
      find(locator).attach_file(filepath)
    end

    def click_apply_button
      apply_button.click
    end

    def click_submit_button
      sleep 2 # temporary -- just for testing
      submit_button.click
    end

    def verify_submission
      sleep 4 # temporary -- just for testing
      # TODO: add logic to check for successful submission message or other indicators
    end

    def doc_tmp_file(file_text)
      docx = Htmltoword::Document.create(file_text)
      filepath = Rails.root.join("tmp", "Cover Letter_#{unique_string}.docx")
      File.binwrite(filepath, docx)
      filepath
    end

    def fill_application_form
      click_apply_button
      fill_in_all_fields
    end

    def fill_in_all_fields
      within(@application_form) do
        @fields.each { |field| fill_in_field(field) }
      end
    end

    def fill_in_field(field)
      fill_in_method = :"handle_#{field[:interaction]}"
      send(fill_in_method, field)
    rescue Capybara::ElementNotFound => e
      p e.message
    end

    def handle_input(field)
      fill_in(field[:locator], with: field[:value])
    end

    def handle_radiogroup(field)
      choose(option: field[:value], name: field[:locator])
    end

    def handle_upload(field)
      file = field[:value]
      filepath = file.instance_of?(String) ? doc_tmp_file(file) : pdf_tmp_file(file)
      attach_file_to_application(filepath, field[:locator])
    end

    def pdf_tmp_file(file)
      filepath = Rails.root.join("tmp", "Resume - #{unique_string}.pdf")
      File.binwrite(filepath, file)
      filepath
    end

    def submit_button
      first(:button, text: /submit/i) || first(:link, text: /submit/i)
    end

    def timestamp
      Time.now.to_s.truncate(19).gsub(/\D/, '')
    end

    def unique_string
      "#{@user_fullname}_#{timestamp}"
    end

    def visit_url
      visit(@url)
      p "Successfully reached #{@url}"
    end
  end
end
