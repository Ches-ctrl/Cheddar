module Ats
  module Workable
    module ApplicationFields
      # Question - scrape all fields or add standard set each time?
      # TODO: Check validatity of fields (not yet tested)
      # TODO: Handle labels from form fields

      def get_application_question_set(_job, data)
        formatted_data = Importer::WorkableFieldsFormatter.call(data.with_indifferent_access)
        Importer::FieldsBuilder.call(formatted_data)
      end

      def update_requirements(_job)
        p "Updating job requirements"
      end

      # Organised into sections (sections have labels)
      NEW_CORE_FIELDS = [
        {
          data_source: "scraping",
          section_slug: "core_fields",
          title: "Main critera",
          description: nil,
          questions: [
            {
              attribute: "first_name",
              required: true,
              label: "First Name",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "firstname",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "last_name",
              required: true,
              label: "Last Name",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "lastname",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "email",
              required: true,
              label: "Email",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "email",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "headline",
              required: true,
              label: "Headline",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "headline",
                  type: 'input_text',
                  max_length: 50,
                  options: []
                }
              ]
            },
            {
              attribute: "phone_number",
              required: true,
              label: "Phone Number",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "phone",
                  type: 'input_text',
                  max_length: 15,
                  options: []
                }
              ]
            },
            {
              attribute: "address_applicant",
              required: false,
              label: "Address",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: "address",
                  type: 'input_text',
                  max_length: 250,
                  options: []
                }
              ]
            },
            {
              attribute: "avatar",
              required: false,
              label: "Avatar",
              description: nil,
              fields: [
                {
                  id: nil,
                  selector: 'input[data-ui="avatar"]',
                  type: "input_file",
                  max_length: nil,
                  options: []
                }
              ]
            },
            {
              attribute: "work_eligibility",
              required: true,
              label: "Work Eligibility",
              description: "Are you eligible to work in the country that the role is listed?",
              fields: [
                {
                  id: nil,
                  selector: "work_eligibility", # TODO : check. Previously: 'input[data-ui="avatar"]'
                  type: 'input_text',
                  max_length: 250,
                  options: []
                }
              ]
            },
            {
              attribute: "salary_expectations",
              required: true,
              label: "Salary expectations",
              description: "What are your annual salary expectations?",
              fields: [
                {
                  id: nil,
                  selector: "salary_expectations", # TODO : check. Previously: 'input[data-ui="avatar"]'
                  type: 'input_text',
                  max_length: 250,
                  options: []
                }
              ]
            }
          ]
        }
      ]

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
