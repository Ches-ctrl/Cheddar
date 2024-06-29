require 'open-uri'
require 'json'
require 'htmltoword'

module Applier
  class FormFiller
    include Capybara::DSL

    # TODO: Handle job posting becoming closed (redirect or notification on page)
    # TODO: Review code for inefficient loops and potential optimisations
    # TODO: Implement caching for both user and form inputs. At the moment we request the database every time we want an input
    # TODO: Cache values at beginning of session and then update cache when user changes values
    # TODO: Enable multi-job application support in form_filler and cache before all applications are submitted
    # TODO: Restrict search to certain portions of the page

    def initialize(url, fields, job_application_id)
      @url = url
      @fields = fields
      @job_application_id = job_application_id
      @job_application = JobApplication.find_by_id(job_application_id)
      @user = @job_application.user
      @job = @job_application.job
      @ats = @job.applicant_tracking_system
      @errors = nil
      # TODO: simplify the instance variables
      # include the relevant ATS form_filler module
      include_ats_module
    end

    def fill_out_form
      submit_application
    end

    private

    def include_ats_module
      ats_name = @ats.name.gsub(/\W/, '').capitalize
      module_name = "Ats::#{ats_name}::SubmitApplication"
      extend Object.const_get(module_name) if Object.const_defined?(module_name)
    end

    def submit_application
      # TODO: Once we have a better sense of how form submission varies by ATS, can refactor so that
      # the generic code goes here and the ATS-specific elements are referred to the ats_module
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
