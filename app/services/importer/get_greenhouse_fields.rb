# frozen_string_literal: true

module Importer
  class GetGreenhouseFields < GetApiFields
    def initialize(data)
      super(data, data_source, sections)
    end

    private

    def add_core_fields_to_fields
      @fields << @core_fields
    end

    def core_questions = @data['questions']

    def create_question(question)
      # TODO: move this logic to parent class
      id = question.dig('fields', 0, 'name')
      core_details = CORE_FIELDS[id] || {}
      question_details(question, core_details)
    end

    def data_source = :api

    def fetch_question_fields(fields)
      fields.map do |field|
        {
          id: field['name'],
          type: standardize_type(field['type']),
          max_length: (255 if field['type'] == 'input_text'),
          options: field['values'].map do |attributes|
            {
              id: attributes['value'],
              label: attributes['label']
            }
          end
        }
      end
    end

    def question_details(question, core_details)
      {
        attribute: question['label'].strip.downcase.gsub(' ', '_'),
        required: question['required'],
        label: question['label'],
        description: question['description'],
        fields: fetch_question_fields(question['fields'])
      }.merge(core_details)
    end

    def sections = [:core]

    def standardize_type(type)
      TYPES[type] || type
    end
  end
end

CORE_FIELDS = {
  'first_name' => {
    attribute: :first_name,
    fields: [
      {
        id: 'first_name',
        selector: nil,
        type: :input,
        max_length: 255,
        options: []
      }
    ]
  },
  'last_name' => {
    attribute: :last_name,
    fields: [
      {
        id: 'last_name',
        selector: nil,
        type: :input,
        max_length: 255,
        options: []
      }
    ]
  },
  'email' => {
    attribute: :email,
    fields: [
      {
        id: 'email',
        selector: nil,
        type: :input,
        max_length: 255,
        options: []
      }
    ]
  },
  'phone' => {
    attribute: :phone_number,
    fields: [
      {
        id: 'phone',
        selector: nil,
        type: :input,
        max_length: 255,
        options: []
      }
    ]
  },
  'location' => {
    attribute: :city_applicant,
    fields: [
      {
        id: 'location',
        selector: nil,
        type: :input,
        max_length: 255,
        options: []
      }
    ]
  },
  'resume' => {
    attribute: :resume,
    fields: [
      {
        id: nil,
        selector: 'button[aria-describedby="resume-allowable-file-types"]',
        type: :upload,
        max_length: 255,
        options: []
      },
      {
        id: 'resume_text',
        selector: nil,
        type: :input,
        options: []
      }
    ]
  },
  'cover_letter' => {
    attribute: :cover_letter,
    fields: [
      {
        id: nil,
        selector: 'button[aria-describedby="cover_letter-allowable-file-types"]',
        type: :upload,
        max_length: 255,
        options: []
      },
      {
        id: 'cover_letter_text',
        selector: nil,
        type: :input,
        options: []
      }
    ]
  }
}

TYPES = {
  'input_file' => :upload,
  'input_text' => :input,
  'multi_value_multi_select' => :multi_select,
  'multi_value_single_select' => :select,
  'textarea' => :input
}
