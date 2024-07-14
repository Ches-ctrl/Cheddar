module Ats
  module Workable
    module ApplicationFields
      # Question - scrape all fields or add standard set each time?
      # TODO: Check validatity of fields (not yet tested)
      # TODO: Handle labels from form fields

      def get_application_criteria(job, _data)
        # TODO: get application_criteria from API
        p "Getting Workable application criteria"
        # job.application_criteria = PERSONAL_FIELDS.merge(PROFILE_FIELDS).merge(DETAILS_FIELDS).merge(ADDITIONAL_FIELDS)
        # job.save
        job.build_application_criterion(form_structure: {
          **PERSONAL_FIELDS,
          **PROFILE_FIELDS,
          **DETAILS_FIELDS,
          **ADDITIONAL_FIELDS
                                        })
        job.save
      end

      def update_requirements(_job)
        p "Updating job requirements"
      end

      # Organised into sections (sections have labels)

      PERSONAL_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'firstname',
          required: true
        },
        last_name: {
          interaction: :input,
          locators: 'lastname',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'email',
          required: true
        },
        headline: {
          interaction: :input,
          locators: 'headline',
          required: true
        },
        phone_number: {
          interaction: :input,
          locators: 'phone',
          required: true
        },
        address: {
          interaction: :input,
          locators: 'address',
          required: false
        },
        avatar: {
          interaction: :upload,
          locators: 'input[data-ui="avatar"]',
          required: false
        },
        work_eligibility: {
          interaction: :input,
          locators: 'input[data-ui="avatar"]',
          required: true
          # label: "Are you eligible to work in the country that the role is listed?"
        },
        salary_expectations: {
          interaction: :input,
          locators: 'input[data-ui="avatar"]',
          required: true
          # label: "What are your annual salary expectations?"
        }
      }

      PROFILE_FIELDS = {
        summary: {
          interaction: :textarea,
          locators: 'summary',
          required: false
        },
        resume: {
          interaction: :upload,
          locators: 'input[data-ui="resume"]',
          required: true
        },
        role_fit: {
          interaction: :textarea,
          locators: 'CA_18008',
          required: true
          # label: "Why do you think you'd be a good fit for the role based on the requirements listed?",
        },
        company_interest: {
          interaction: :textarea,
          locators: 'CA_18009',
          required: true
          # label: "Why do you think you'd be a good fit for the role based on the requirements listed?",
        }
      }

      DETAILS_FIELDS = {
        cover_letter: {
          interaction: :textarea,
          locators: 'cover_letter',
          required: false
        },
        visa_sponsorship: {
          interaction: :radiogroup,
          locators: 'QA_6167680',
          required: false
        }
      }

      ADDITIONAL_FIELDS = {}

      DEGREE_OPTIONS = []

      DISCIPLINE_OPTIONS = []
    end
  end
end
