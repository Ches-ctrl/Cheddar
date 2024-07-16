# frozen_string_literal: true

module Importer
  class GetGreenhouseFields < GetApiFields
    def initialize(data)
      super(data, data_source, sections)
    end

    private

    def core_questions = @data['questions']

    def data_source = :api

    def field_id(field) = field['name']

    def field_max_length(field) = (255 if field_type(field) == 'input_text')

    def field_options(field) = field['values']

    def field_type(field) = field['type']

    def option_id(option) = option['value']

    def option_label(option) = option['label']

    def question_description = @question['description']

    def question_fields = @question['fields']

    def question_id = @question.dig('fields', 0, 'name')

    def question_label = @question['label']

    def question_required? = @question['required']

    def sections = [:core]
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
