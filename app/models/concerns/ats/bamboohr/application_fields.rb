module Ats
  module Bamboohr
    module ApplicationFields
      def get_application_criteria(job, data)
        p "Getting BambooHR application criteria"

        job.application_criteria = build_application_criteria_from(data['formFields'])
        job.save
        # GetFormFieldsJob.perform_later(job.posting_url)
      end

      private

      def build_application_criteria_from(fields)
        attributes = {}

        fields.each do |locator, details|
          field = details.instance_of?(Array) ? build_additional_field(details) : build_core_field(locator, details)
          attributes.merge!(field)
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
              locators: field['id'],
              required: field['isRequired'],
              options:
            }.compact
          )
        end
      end

      def fetch_field_attributes(field)
        name = field['question']
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
        'First Name' => {
          interaction: :input,
          locators: 'firstName'
        },
        'Last Name' => {
          interaction: :input,
          locators: 'lastName'
        },
        'Email' => {
          interaction: :input,
          locators: 'email'
        },
        'Phone' => {
          interaction: :input,
          locators: 'phone'
        },
        'Address' => {
          interaction: :input,
          locators: 'streetAddress'
        },
        'City' => {
          interaction: :input,
          locators: 'city'
        },
        'State' => {
          interaction: :select,
          locators: 'state'
          # locators: 'fab-SelectToggle__placeholder'
        },
        'ZIP' => {
          interaction: :input,
          locators: 'zip'
        },
        'Country' => {
          interaction: :input,
          locators: 'countryId'
        },
        'Website, Blog, or Portfolio' => {
          interaction: :input,
          locators: 'websiteUrl'
        },
        'LinkedIn Profile URL' => {
          interaction: :input,
          locators: 'linkedinUrl'
        },
        'Cover Letter' => {
          interaction: :upload,
          locators: 'coverLetterFileId'
        },
        'Resume' => {
          interaction: :upload,
          locators: 'resumeFileId'
        },
        'Date Available' => {
          interaction: :date,
          locators: 'dateAvailable'
        },
        'Desired Pay' => {
          interaction: :input,
          locators: 'desiredPay'
        }
      }
    end
  end
end
