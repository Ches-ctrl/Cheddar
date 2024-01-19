module Ats::Lever::ApplicationFields
  extend ActiveSupport::Concern

  def self.get_application_criteria(job)
    p "Getting lever application criteria"
    job.application_criteria = SUBMIT_FIELDS.merge(SOURCE_FIELDS).merge(DETAILS_FIELDS).merge(ADDITIONAL_FIELDS)
    job.save
    # GetFormFieldsJob.perform_later(job.job_posting_url)
  end

  SUBMIT_FIELDS = {
    resume: {
      interaction: :upload,
      locators: 'input-resume',
      required: true,
    },
    full_name: {
      interaction: :input,
      locators: 'name-input',
      required: true,
    },
    pronouns: {
      interaction: :checkbox,
      locators: 'candidatePronounsCheckboxes',
      required: false,
    },
    email: {
      interaction: :input,
      locators: 'email-input',
      required: true,
    },
    phone: {
      interaction: :input,
      locators: 'phone-input',
      required: true,
    },
    current_company: {
      interaction: :input,
      locators: 'org-input',
      required: false,
    },
  }

  # TODO: Add categories for source fields to match form?

  CUSTOM_FIELDS = {
    hear_about: {
      interaction: :input,
      locators: 'cards[4d3da8ca-48dc-4ff6-8164-c5dc617b1172][field0]',
      required: true,
      # label: "How did you hear about Zeneducate?",
    },
    domain_yoe: {
      interaction: :input,
      locators: '',
      required: true,
      # label: "",
    },
  }

  DEGREE_OPTIONS = []

  DISCIPLINE_OPTIONS = []
end
