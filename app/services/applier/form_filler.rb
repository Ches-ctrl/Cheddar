# frozen_string_literal: true

module Applier
  class FormFiller < ApplicationTask
    include Capybara::DSL
    include LoggingHelper

    def initialize(payload)
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
      find(:css, 'button, a', text: /apply/i, match: :first)
    end

    def attach_file_to_application
      attach_file(@locator, @filepath)
    end

    def click_apply_button
      apply_button.click
    end

    def click_submit_button
      sleep 2 # temporary -- just for testing
      submit_button.click
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

    def handle_input
      verify_input { fill_in(@locator, with: @value) }
    end

    def handle_radiogroup
      choose(option: @value, name: @locator)
    end

    def handle_multi_select
      within response_field do
        @value.each { |value| check(value) }
      end
    end

    def handle_upload
      @value.instance_of?(String) ? doc_tmp_file : pdf_tmp_file
      attach_file_to_application
    end

    def pdf_tmp_file
      @filepath = Rails.root.join("tmp", "Resume - #{unique_string}.pdf")
      File.binwrite(@filepath, @value)
    end

    def response_field
      first('label', text: @locator)
    rescue Capybara::ElementNotFound
      first('div', text: @locator)
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

    def verify_input(retries = 3)
      returned_value = yield.value
      raise Applier::IncorrectInputError unless returned_value == @value
    rescue Applier::IncorrectInputError
      retries -= 1
      retry unless retries.negative?
    end

    def verify_submission
      sleep 4 # temporary -- just for testing
      # TODO: add logic to check for successful submission message or other indicators
    end

    def visit_url
      visit(@url)
      p "Successfully reached #{@url}"
    end
  end
end
