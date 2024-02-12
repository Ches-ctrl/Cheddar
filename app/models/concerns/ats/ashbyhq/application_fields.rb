module Ats::Ashbyhq::ApplicationFields
  extend ActiveSupport::Concern

  def self.get_application_criteria(job)
    p "Getting AshbyHQ application criteria"
    job.application_criteria = CANDIDATE_FIELDS.merge(LOCATION_FIELDS).merge(WORKAUTH_FIELDS)
    job.save
    # GetFormFieldsJob.perform_later(job.job_posting_url)
  end

  def self.update_requirements(job)
    p "Updating job requirements"
  end

  # Organised into sections (sections have labels)

  CANDIDATE_FIELDS = {
    first_name: {
      interaction: :input,
      locators: 'firstname',
      required: true,
    },
    last_name: {
      interaction: :input,
      locators: 'lastname',
      required: true,
    },
    email: {
      interaction: :input,
      locators: 'email',
      required: true,
    },
  }

  LOCATION_FIELDS = {
    summary: {
      interaction: :textarea,
      locators: 'summary',
      required: false,
    },
    resume: {
      interaction: :upload,
      locators: 'input[data-ui="resume"]',
      required: true,
    },
  }

  WORKAUTH_FIELDS = {
    cover_letter: {
      interaction: :textarea,
      locators: 'cover_letter',
      required: false,
    },
    visa_sponsorship: {
      interaction: :radiogroup,
      locators: 'QA_6167680',
      required: false
    }
  }

  DEGREE_OPTIONS = []

  DISCIPLINE_OPTIONS = []
end
