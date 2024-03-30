module Ats
  module Devit
    module ApplicationFields
      # Question - scrape all fields or add standard set each time?

      def get_application_criteria(job)
        job.application_criteria = CORE_FIELDS
        job.save
      end

      CORE_FIELDS = {
        full_name: {
          interaction: :input,
          locators: 'name',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'email',
          required: true
        },
        uk_citizen_or_resident: {
          interaction: :checkbox, # actually a pair of radio buttons
          locators: 'isFromEurope',
          required: true
        },
        resume: {
          interaction: :upload,
          locators: 'cvFile',
          required: true
        },
        cover_letter: {
          interaction: :textarea,
          locators: 'textarea[name="motivationLetter"]',
          required: true
          # placeholder: "Motivation Letter - Write why have you chosen this job? (adding links to your GitHub or LinkedIn will increase your chances). Companies appreciate it when you write more and tell why you want to work there."
        }
      }
    end
  end
end
