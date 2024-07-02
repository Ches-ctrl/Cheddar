# frozen_string_literal: true

# require 'open-uri'
# require 'json'
# require 'htmltoword'

# TODO: Handle job posting becoming closed (redirect or notification on page)
module Applier
  # Core class for filling out forms using Capybara
  class FormFiller < ApplicationTask
    include Capybara::DSL

    def initialize(url, payload, job_application)
      @url = url
      @fields = payload
      @job_application = job_application
      @ats = @job_application.job.applicant_tracking_system
      # @user = @job_application.application_process.user
      @errors = nil

      # include the relevant ATS form_filler module
      include_ats_module
    end

    def call
      return unless processable

      process
    rescue StandardError => e
      Rails.logger.error "Error running FormFiller: #{e.message}"
      nil
    end

    private

    def processable
      @url && @fields && @job_application && @ats
    end

    def process
      p "Hello from FormFiller!"
      submit_application
    end

    private

    def include_ats_module
      ats_name = @ats.name.gsub(/\W/, '').capitalize
      module_name = "Ats::#{ats_name}::SubmitApplication"
      extend Object.const_get(module_name) if Object.const_defined?(module_name)
    end

    def submit_application
      return super if defined?(super)

      puts "Write a submit method for #{@ats.name}!"
      return
    end

    def take_screenshot_and_store(session, job_application)
      screenshot_path = Rails.root.join('tmp', "screenshot-#{job_application.id}.png")
      session.save_screenshot(screenshot_path)

      file = File.open(screenshot_path)
      job_app = job_application
      job_app.screenshot.attach(io: file, filename: "screenshot-#{job_application.id}.png", content_type: 'image/png')

      File.delete(screenshot_path)
    end
  end
end
