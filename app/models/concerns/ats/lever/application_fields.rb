module Ats
  module Lever
    module ApplicationFields
      def get_application_question_set(_job, _data)
        p "Getting lever application criteria"

        # TODO : implement new application_question_structure structure
        # job.application_question_set = CORE_FIELDS.merge(CUSTOM_FIELDS)
        []
      end

      CORE_FIELDS = {
        resume: {
          interaction: :upload,
          locators: 'input-resume',
          required: true
        },
        full_name: {
          interaction: :input,
          locators: 'name-input',
          required: true
        },
        pronouns: {
          interaction: :checkbox,
          locators: 'candidatePronounsCheckboxes',
          required: false
        },
        email: {
          interaction: :input,
          locators: 'email-input',
          required: true
        },
        phone: {
          interaction: :input,
          locators: 'phone-input',
          required: true
        },
        current_company: {
          interaction: :input,
          locators: 'org-input',
          required: false
        }
      }

      # TODO: Add categories for source fields to match form?

      CUSTOM_FIELDS = {
        hear_about: {
          interaction: :input,
          locators: 'cards[4d3da8ca-48dc-4ff6-8164-c5dc617b1172][field0]',
          required: true
          # label: "How did you hear about Zeneducate?",
        },
        domain_yoe: {
          interaction: :input,
          locators: 'cards[fe9a213f-b5c3-4e95-86c3-c02b1767b8d4][field0]',
          required: true
          # label: "How many years of experience do you have with Ruby on Rails?",
        },
        tech_yoe: {
          interaction: :input,
          locators: 'cards[fe9a213f-b5c3-4e95-86c3-c02b1767b8d4][field1]',
          required: true
          # label: "How many years of experience do you have with React?",
        },
        additional_information: {
          interaction: :textarea,
          locators: 'additional-information',
          required: false
          # placeholder: "Add a cover letter or anything else you want to share.",
        }
      }
    end
  end
end
