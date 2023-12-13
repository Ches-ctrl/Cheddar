class JobApplication < ApplicationRecord

  # -----------------------------
  # Core Application Criteria:
  # -----------------------------

  CORE_APPLICATION_CRITERIA = {
    first_name: {
      interaction: :input,
    },
    last_name: {
      interaction: :input,
    },
    email: {
      interaction: :input,
    },
    phone_number: {
      interaction: :input,
    },
    resume: {
      interaction: :upload,
    },
    # city: {
    #   interaction: :input,
    # },
    # location_click: {
    #   interaction: :listbox,
    # },
    # linkedin_profile: {
    #   interaction: :input,
    # },
    # personal_website: {
    #   interaction: :input,
    # },
    # heard_from: {
    #   interaction: :input,
    # },
    # # right_to_work: {
    # #   interaction: :select,
    # # },
    # require_visa?: {
    #   interaction: :select,
    # },
  }

  belongs_to :user
  belongs_to :job
  has_many :application_responses, dependent: :destroy

  accepts_nested_attributes_for :application_responses

  has_one_attached :screenshot

  # TODO: Add validations for the job application model
  # TODO: have a complete message taken from the application page on successful execution
end
