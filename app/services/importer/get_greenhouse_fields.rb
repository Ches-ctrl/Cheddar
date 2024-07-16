# frozen_string_literal: true

module Importer
  class GetGreenhouseFields < GetApiFields
    def initialize(data)
      options = {
        data_source:,
        sections:,
        standard_fields: STANDARD_FIELDS,
        types: TYPES
      }
      super(data, options)
    end

    private

    def core_questions = @data['questions']

    def data_source = :api

    def demographic_questions = @data.dig('demographic_questions', 'questions')

    def demographic_section_description = @data.dig('demographic_questions', 'description')

    def demographic_section_title = @data.dig('demographic_questions', 'header')

    def compliance_questions
      @data['compliance']&.inject([]) do |questions, section|
        questions + section['questions'].map do |question|
          {
            'description' => section['description']
          }.merge(question)
        end
      end&.compact
    end

    def location_questions = nil

    def location_section_description = nil

    def location_section_title = nil

    def compliance_section_title = 'EEOC compliance questions'

    def compliance_section_description = @data.dig('compliance', 0, 'description')

    def convert_to_numerical_id(value) = value.is_a?(String) ? value.sub(/question_(?=\d+)/, '') : value

    def field_id(field) = convert_to_numerical_id(field['name'])

    def field_max_length(field) = (255 if field_type(field) == 'input_text')

    def field_options(field) = field['values'] || field['answer_options']

    def field_type(field) = field['type']

    def option_id(option) = option['value'] || option['id']

    def option_label(option) = option['label']

    def option_free_form(option) = option['free_form']

    def option_decline_to_answer(option) = option['decline_to_answer']

    def question_description = @question['description']

    def question_fields = @question['fields'] || [@question]

    def question_id = @question.dig('fields', 0, 'name')

    def question_label = @question['label']

    def question_required? = @question['required']

    def sections = %i[core demographic compliance location]
  end
end

STANDARD_FIELDS = {
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
