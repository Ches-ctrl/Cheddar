module Ats
  module Bamboohr
    module ApplicationFields
      def get_application_question_set(job, data)
        p "Getting BambooHR application criteria"

        job.application_question_set = build_application_question_set_from(data['formFields'])
        job.save
      end

      private

      def build_application_question_set_from(fields)
        attributes = {}

        fields.each do |locator, details|
          field = details.instance_of?(Array) ? build_additional_field(details) : build_core_field(locator, details)
          attributes.merge!(field)
        rescue StandardError => e
          p "Error building application criteria: #{e.message}"
          {}
        end

        return attributes
      end

      def build_core_field(locator, data)
        name, details = CORE_FIELDS.find { |_, attributes| attributes[:locators] == locator }
        {
          name => details.merge(
            required: data['isRequired'],
            options: data['options']&.map { |option| option['text'] }
          ).compact
        }
      end

      def build_additional_field(data)
        data.inject({}) do |question_set, field|
          name, interaction, options = fetch_field_attributes(field)
          question_set.merge!(
            name => {
              interaction:,
              label: field['question'],
              locators: field['id'],
              required: field['isRequired'],
              options:
            }.compact
          )
        end
      end

      def fetch_field_attributes(field)
        name = field['question'].downcase.gsub(' ', '_').gsub(/[^a-z0-9_-]/, '')
        options = field['options']&.map { |option| option['text'] } unless field['options'].blank?
        interaction = FIELD_TYPES[field['type']]
        if interaction == :boolean
          options ||= ['Yes', 'No']
          interaction = :select
        end
        [name, interaction, options]
      end

      FIELD_TYPES = {
        'short' => :input,
        'long' => :input,
        'checkbox' => :boolean,
        'yes_no' => :boolean
      }

      CORE_FIELDS = {
        first_name: {
          interaction: :input,
          locators: 'firstName',
          label: 'First Name',
          core_field: true
        },
        last_name: {
          interaction: :input,
          locators: 'lastName',
          label: 'Last Name',
          core_field: true
        },
        email: {
          interaction: :input,
          locators: 'email',
          label: 'Email',
          core_field: true
        },
        phone_number: {
          interaction: :input,
          locators: 'phone',
          label: 'Phone',
          core_field: true
        },
        address: {
          interaction: :input,
          locators: 'streetAddress',
          label: 'Address',
          core_field: true
        },
        city: {
          interaction: :input,
          locators: 'city',
          label: 'City',
          core_field: true
        },
        state: {
          interaction: :select,
          locators: 'state',
          label: 'State',
          core_field: true
        },
        post_code: {
          interaction: :input,
          locators: 'zip',
          label: 'ZIP',
          core_field: true
        },
        country: {
          interaction: :input,
          locators: 'countryId',
          label: 'Country',
          core_field: true
        },
        website_url: {
          interaction: :input,
          locators: 'websiteUrl',
          label: 'Website, Blog, or Portfolio',
          core_field: true
        },
        linkedin_url: {
          interaction: :input,
          locators: 'linkedinUrl',
          label: 'LinkedIn Profile URL',
          core_field: true
        },
        cover_letter: {
          interaction: :upload,
          locators: 'coverLetterFileId',
          label: 'Cover Letter',
          core_field: true
        },
        resume: {
          interaction: :upload,
          locators: 'resumeFileId',
          label: 'Resume',
          core_field: true
        },
        education_level: {
          interaction: :select,
          locators: 'educationLevelId',
          label: 'Highest Education Obtained',
          core_field: true
        },
        education_school: {
          interaction: :input,
          locators: 'educationInstitutionName',
          label: 'College/University',
          core_field: true
        },
        date_available: {
          interaction: :date,
          locators: 'dateAvailable',
          label: 'Date Available',
          core_field: true
        },
        desired_pay: {
          interaction: :input,
          locators: 'desiredPay',
          label: 'Desired Pay',
          core_field: true
        },
        referred_by: {
          interaction: :input,
          locators: 'referredBy',
          label: 'Who referred you for this position?',
          core_field: true
        },
        gender: {
          interaction: :select,
          locators: 'genderId',
          label: 'Gender'
        },
        ethnicity: {
          interaction: :select,
          locators: 'ethnicityId',
          label: 'Ethnicity'
        },
        disability: {
          interaction: :select,
          locators: 'disabilityId',
          label: 'Disability'
        },
        veteran_status: {
          interaction: :select,
          locators: 'veteranStatusId',
          label: 'Veteran Status'
        }
      }
    end
  end
end
