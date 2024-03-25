module Ats
  module Bamboohr
    module ApplicationFields

      def self.get_application_criteria(job)
        p "Getting Bamboohr application criteria"
        job.application_criteria = CORE_FIELDS
        job.save
        # GetFormFieldsJob.perform_later(job.job_posting_url)
      end

      CORE_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'firstName',
          required: true
        },
        last_name: {
          interaction: :input,
          locators: 'lastName',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'email',
          required: true
        },
        phone: {
          interaction: :input,
          locators: 'phone',
          required: true
        },
        address: {
          interaction: :input,
          locators: 'streetAddress',
          required: false
        },
        city: {
          interaction: :input,
          locators: 'city',
          required: false
        },
        state: {
          interaction: :select,
          locators: 'fab-SelectToggle__placeholder',
          required: false
        },
        country: {
          interaction: :select,
          locators: 'streetAddress',
          required: false
        },
        postcode: {
          interaction: :input,
          locators: 'zip`',
          required: false
        },
        cover_letter: {
          interaction: :upload,
          locators: 'coverLetterFileId',
          required: true
        },
        available_date: {
          interaction: :input,
          locators: 'dateAvailable',
          required: true
        }
      }
    end
  end
end
