module Ats
  module Pinpointhq
    module ApplicationFields
      extend ActiveSupport::Concern

      def self.get_application_criteria(job)
        p "Getting PinpointHQ application criteria"
        job.application_criteria = CORE_FIELDS.merge(PROFILE_FIELDS).merge(QUESTION_FIELDS).merge(DIVERSITY_FIELDS)
        job.save
        # GetFormFieldsJob.perform_later(job.job_posting_url)
      end

      CORE_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'application_form_application_first_name',
          required: true
        },
        last_name: {
          interaction: :input,
          locators: 'application_form_application_last_name',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'application_form_application_email',
          required: true
        },
        phone: {
          interaction: :input,
          locators: 'application_form_application_phone',
          required: true
        },
        country: {
          interaction: :input,
          locators: 'application_form[application][country]',
          required: true
        }
      }

      PROFILE_FIELDS = {
        XX: {
          interaction: :input,
          locators: 'linkedin-input',
          required: false
        }
      }

      QUESTION_FIELDS = {
        XX: {
          interaction: :upload,
          locators: 'resume-upload',
          required: true
        }
      }

      DIVERSITY_FIELDS = {
        XX: {
          interaction: :upload,
          locators: 'resume-upload',
          required: true
        }
      }
    end
  end
end
