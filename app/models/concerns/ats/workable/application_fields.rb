module Ats::Workable::ApplicationFields
  extend ActiveSupport::Concern

  # Question - scrape all fields or add standard set each time?

  def self.get_application_criteria(job)
    p "Getting greenhouse application criteria"
    job.application_criteria = CORE_FIELDS
    job.save
    # GetFormFieldsJob.perform_later(job.job_posting_url)
  end

  def self.update_requirements(job)
    p "Updating job requirements"
  end

  CORE_FIELDS = {
    # first_name: {
    #   interaction: :input,
    #   locators: 'first_name',
    #   required: true,
    # },
    # last_name: {
    #   interaction: :input,
    #   locators: 'last_name',
    #   required: true,
    # },
    # email: {
    #   interaction: :input,
    #   locators: 'email',
    #   required: true,
    # },
    # phone_number: {
    #   interaction: :input,
    #   locators: 'phone',
    #   required: true,
    # },
    # city: {
    #   interaction: :input,
    #   locators: 'job_application[location]',
    #   required: true,
    # },
    # location_click: {
    #   interaction: :listbox,
    #   locators: 'ul#location_autocomplete-items-popup'
    # },
    # resume: {
    #   interaction: :upload,
    #   locators: 'button[aria-describedby="resume-allowable-file-types"',
    #   required: true,
    # },
    # cover_letter: {
    #   interaction: :upload,
    #   locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
    #   required: false
    # }
  }

  ADDITIONAL_FIELDS = {
    # school: {
    #   interaction: :select,
    #   locators: 's2id_education_school_name_0',
    #   required: true,
    #   placeholder: 'Select a School',
    #   data_url: 'https://boards-api.greenhouse.io/v1/boards/phonepe/education/schools',
    # },
    # degree: {
    #   interaction: :select,
    #   locators: 's2id_education_degree_0',
    #   required: false,
    # },
    # discipline: {
    #   interaction: :select,
    #   locators: 's2id_education_discipline_0',
    #   required: false,
    # },
    # ed_start_date_year: {
    #   interaction: :input,
    #   locators: 'job_application[educations][][start_date][year]',
    #   required: true,
    # },
    # ed_end_date_year: {
    #   interaction: :input,
    #   locators: 'job_application[educations][][end_date][year]',
    #   required: true,
    # },
    # company_name: {
    #   interaction: :input,
    #   locators: 'job_application[employments][][company_name]',
    #   required: true,
    # },
    # title: {
    #   interaction: :input,
    #   locators: 'job_application[employments][][title]',
    #   required: true,
    # },
    # emp_start_date_month: {
    #   interaction: :input,
    #   locators: 'job_application[employments][][start_date][month]',
    #   required: true,
    # },
    # emp_start_date_year: {
    #   interaction: :input,
    #   locators: 'job_application[employments][][start_date][year]',
    #   required: true,
    # },
    # emp_end_date_month: {
    #   interaction: :input,
    #   locators: 'job_application[employments][][end_date][month]',
    #   required: true,
    # },
    # emp_end_date_year: {
    #   interaction: :input,
    #   locators: 'job_application[employments][][end_date][year]',
    #   required: true,
    # },
    # linkedin_profile: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-linkedin-profile"]',
    #   required: false,
    # },
    # personal_website: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
    #   required: false,
    # },
    # gender: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-website"], input[autocomplete="custom-question-portfolio-linkwebsite"]',
    #   required: false,
    # },
    # location_click: {
    #   interaction: :listbox,
    #   locators: 'ul#location_autocomplete-items-popup'
    # },

    # heard_from: {
    #   interaction: :input,
    #   locators: 'input[autocomplete="custom-question-how-did-you-hear-about-this-job"]'
    # },
    # require_visa?: {
    #   interaction: :input,
    #   locators: 'textarea[autocomplete="custom-question-would-you-need-sponsorship-to-work-in-the-uk-"]'
    # },
  }

  DEGREE_OPTIONS = []

  DISCIPLINE_OPTIONS = []
end
