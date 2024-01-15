module Ats::Workable::ApplicationFields
  extend ActiveSupport::Concern

  # Question - scrape all fields or add standard set each time?
  # TODO: Handle labels from form fields

  def self.get_application_criteria(job)
    p "Getting greenhouse application criteria"
    job.application_criteria = CORE_FIELDS
    job.save
    # GetFormFieldsJob.perform_later(job.job_posting_url)
  end

  def self.update_requirements(job)
    p "Updating job requirements"
  end

  PERSONAL_FIELDS = {
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
    headline: {
      interaction: :input,
      locators: 'headline',
      required: true,
    },
    phone_number: {
      interaction: :input,
      locators: 'phone',
      required: true,
    },
    address: {
      interaction: :input,
      locators: 'address',
      required: false,
    },
    avatar: {
      interaction: :upload,
      locators: 'input[data-ui="avatar"]',
      required: false,
    },
    work_eligibility: {
      interaction: :input,
      locators: 'input[data-ui="avatar"]',
      required: true,
      # label: "Are you eligible to work in the country that the role is listed?"
    },
    salary_expectations: {
      interaction: :input,
      locators: 'input[data-ui="avatar"]',
      required: true,
      # label: "What are your annual salary expectations?"
    },
  }

  PROFILE_FIELDS = {
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
    # cover_letter: {
    #   interaction: :upload,
    #   locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
    #   required: false
    # }
  }

  ADDITIONAL_FIELDS = {
  }

  DEGREE_OPTIONS = []

  DISCIPLINE_OPTIONS = []
end
