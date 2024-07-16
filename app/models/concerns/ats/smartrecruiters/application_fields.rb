module Ats
  module Smartrecruiters
    module ApplicationFields
      def get_application_question_set(job, _data)
        p "Getting smartrecruiters application criteria"
        job.application_question_set = CORE_FIELDS.merge(WEB_FIELDS).merge(ADDITIONAL_FIELDS)
        job.save
      end

      CORE_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'name-input',
          required: true
        },
        last_name: {
          interaction: :input,
          locators: 'name-input',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'email-input',
          required: true
        },
        email_confirm: {
          interaction: :input,
          locators: 'confirm-email-input',
          required: true
        },
        residence: {
          interaction: :select,
          locators: 'sr-location-autocomplete',
          required: false
        },
        country: {
          interaction: :text,
          locators: 'sr-location-country-required',
          required: true
        },
        city: {
          interaction: :select,
          locators: 'sr-location-city-required',
          required: true
        },
        phone: {
          interaction: :input,
          locators: 'phone-number-input',
          required: true
        }
      }

      WEB_FIELDS = {
        linkedin: {
          interaction: :input,
          locators: 'linkedin-input',
          required: false
        },
        facebook: {
          interaction: :input,
          locators: 'linkedin-input',
          required: false
        },
        twitter: {
          interaction: :input,
          locators: 'twitter-input',
          required: false
        },
        website: {
          interaction: :input,
          locators: 'website-input',
          required: false
        }
      }

      ADDITIONAL_FIELDS = {
        resume: {
          interaction: :upload,
          locators: 'resume-upload',
          required: true
        },
        hiring_manager_message: {
          interaction: :textarea,
          locators: 'hiring-manager-message-input',
          required: false
        }
      }
    end
  end
end
