module Ats::Workday
  extend ActiveSupport::Concern

  def self.get_company_details(company)
    p "Getting Workday company details: #{company}"
  end

  def self.get_job_details(job)
    p "Getting Workday job details: #{job}"
  end

  XXX_CORE_FIELDS = {
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
    # resume: {
    #   interaction: :upload,
    #   locators: 'button[aria-describedby="resume-allowable-file-types"',
    #   required: true,
    # },
    # cover_letter: {
    #   interaction: :upload,
    #   locators: 'button[aria-describedby="cover_letter-allowable-file-types"]',
    #   required: false,
    # },
  }

  XXX_ADDITIONAL_FIELDS = {
  }

  XXX_DEGREE_OPTIONS = [
  ]

  XXX_DISCIPLINE_OPTIONS = [
  ]
end
