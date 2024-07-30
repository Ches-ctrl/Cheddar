# frozen_string_literal: true

module Importer
  class GetBambooFields < GetApiFields
    def initialize(job, data)
      options = {
        data_source: :api,
        sections: %i[core additional],
        standard_fields: STANDARD_FIELDS,
        types: TYPES
      }

      super(job, data, options)
    end

    private

    def additional_questions = @data.dig('formFields', 'customQuestions') || []

    def additional_section_description = nil

    def additional_section_title = 'Additional questions'

    def convert_custom_questions_id(value)
      "customQuestions[#{value}]"
    end

    def core_questions
      @data['formFields'].map { |e| { id: e.first }.merge(e.second) if e.second.is_a?(Hash) }.compact
    end

    def create_question = deep_merge(core_details, question_details)

    def deep_merge(core, question)
      core.merge(question) { |key, a, b| key == :fields ? a[0].merge(b[0]) : a }
    end

    def field_id(field) = question_id(field)

    def field_max_length(field) = (255 if field_type(field) == 'input_text') # check this

    def field_options(field) = field['options'] || []

    def field_type(field) = field['type']

    def option_id(option) = option['id']

    def option_label(option) = option['text']

    def option_free_form(_option) = nil

    def option_decline_to_answer(_option) = nil

    def question_fields = [@question]

    def question_details
      {
        required: question_required?,
        label: question_label,
        fields: fetch_question_fields
      }
    end

    def question_id(question) = question[:id] || convert_custom_questions_id(question['id'])

    def question_label = @question['question']

    def question_required? = @question['isRequired']

    EDUCATION_FIELDS = [
      'school',
      'degree',
      'discipline',
      'start_date',
      'end_date'
    ]

    STANDARD_FIELDS = {
      'firstName' => {
        label: 'First Name',
        attribute: :first_name,
        fields: [
          {
            id: 'firstName',
            type: :input,
            options: []
          }
        ]
      },
      'lastName' => {
        attribute: :last_name,
        label: 'Last Name',
        fields: [
          {
            id: 'lastName',
            type: :input,
            options: []
          }
        ]
      },
      'email' => {
        attribute: :email,
        label: 'Email',
        fields: [
          {
            id: 'email',
            type: :input,
            options: []
          }
        ]
      },
      'phone' => {
        attribute: :phone_number,
        label: 'Phone',
        fields: [
          {
            id: 'phone',
            type: :input,
            options: []
          }
        ]
      },
      'streetAddress' => {
        attribute: :address_applicant,
        label: 'Address',
        fields: [
          {
            id: 'streetAddress',
            type: :input,
            options: []
          }
        ]
      },
      'city' => {
        attribute: :city_applicant,
        label: 'City',
        fields: [
          {
            id: 'city',
            type: :input,
            options: []
          }
        ]
      },
      'state' => {
        attribute: :county_applicant,
        label: 'County', # this will vary by country
        fields: [
          {
            id: 'state',
            type: :select
          }
        ]
      },
      'zip' => {
        attribute: :postcode_applicant,
        label: 'Postcode', # this will vary by country
        fields: [
          {
            id: 'zip',
            type: :input,
            options: []
          }
        ]
      },
      'countryId' => {
        attribute: :country_applicant,
        label: 'Country',
        fields: [
          {
            id: 'countryId',
            type: :input
          }
        ]
      },
      'websiteUrl' => {
        attribute: :website_url,
        label: 'Website, Blog, or Portfolio',
        fields: [
          {
            id: 'websiteUrl',
            type: :input,
            options: []
          }
        ]
      },
      'linkedinUrl' => {
        attribute: :linkedin_url,
        label: 'LinkedIn Profile URL',
        fields: [
          {
            id: 'linkedinUrl',
            type: :input,
            options: []
          }
        ]
      },
      'coverLetterFileId' => {
        attribute: :cover_letter,
        label: 'Cover Letter',
        fields: [
          {
            id: 'coverLetterFileId',
            type: :upload,
            options: []
          }
        ]
      },
      'resumeFileId' => {
        attribute: :resume,
        label: 'Resume',
        fields: [
          {
            id: 'resumeFileId',
            type: :upload,
            options: []
          }
        ]
      },
      'educationLevelId' => {
        attribute: :education_level_applicant,
        label: 'Highest Education Obtained',
        fields: [
          {
            id: 'educationLevelId',
            type: :select,
            options: []
          }
        ]
      },
      'educationInstitutionName' => {
        attribute: :school_applicant,
        label: 'College/University',
        fields: [
          {
            id: 'educationInstitutionName',
            type: :input,
            options: []
          }
        ]
      },
      'dateAvailable' => {
        attribute: :date_available,
        label: 'Date Available',
        fields: [
          {
            id: 'dateAvailable',
            type: :date,
            options: []
          }
        ]
      },
      'desiredPay' => {
        attribute: :desired_pay,
        label: 'Desired Pay',
        fields: [
          {
            id: 'desiredPay',
            type: :input,
            options: []
          }
        ]
      },
      'referredBy' => {
        attribute: :referred_by,
        label: 'Who referred you for this position?',
        fields: [
          {
            id: 'referredBy',
            type: :input,
            options: []
          }
        ]
      },
      'genderId' => {
        attribute: :gender,
        label: 'Gender',
        fields: [
          {
            id: 'genderId',
            type: :select,
            options: []
          }
        ]
      },
      'ethnicityId' => {
        attribute: :ethnicity,
        label: 'Ethnicity',
        fields: [
          {
            id: 'ethnicityId',
            type: :select,
            options: []
          }
        ]
      },
      'disabilityId' => {
        attribute: :disability,
        label: 'Disability',
        fields: [
          {
            id: 'disabilityId',
            type: :select,
            options: []
          }
        ]
      },
      'veteranStatusId' => {
        attribute: :veteran_status,
        label: 'Veteran Status',
        fields: [
          {
            id: 'veteranStatusId',
            type: :select,
            options: []
          }
        ]
      }
    }

    TYPES = {
      'checkbox' => :boolean,
      'long' => :textarea,
      'short' => :input,
      'yes_no' => :boolean
    }
  end
end
