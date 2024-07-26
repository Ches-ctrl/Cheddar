# frozen_string_literal: true

module Importer
  # company_id is the ATS identifier for the company
  # Needs the company_id to fetch the education options
  class GetGreenhouseFields < GetApiFields
    def initialize(job, data)
      @company_id = job.company.ats_identifier

      options = {
        data_source: :api,
        sections: %i[core demographic compliance],
        standard_fields: STANDARD_FIELDS,
        types: TYPES
      }

      super(job, data, options)
    end

    private

    def build_education_question(type)
      question = @standard_fields[type].merge(required: @education_required)
      question[:fields][0][:options] = Importer::GreenhouseEducationOptionsFetcher.call(@company_id, type)
      question
    end

    def build_fields
      super
      insert_education_questions if education_question_present?
    end

    def compliance_questions
      @data['compliance']&.flat_map do |section|
        section['questions'].map do |question|
          { 'description' => section['description'] }.merge(question)
        end
      end&.compact
    end

    def compliance_section_title = 'EEOC compliance questions'

    def compliance_section_description = @data.dig('compliance', 0, 'description')

    def convert_to_numerical_id(value) = value.is_a?(String) && value =~ /question_(\d+)/ ? ::Regexp.last_match(1) : value.to_s

    def core_questions
      questions = @data['questions']
      questions = insert_questions(questions, location_questions, :insert_before, 'resume') if location_question_present?
      questions
    end

    def demographic_questions = @data.dig('demographic_questions', 'questions')

    def demographic_section_description = @data.dig('demographic_questions', 'description')

    def demographic_section_title = @data.dig('demographic_questions', 'header')

    def education_question_present? = @data['education'].present?

    def education_questions = EDUCATION_FIELDS.map { |type| build_education_question(type) }

    def field_id = convert_to_numerical_id(@field['name'] || @field['id'])

    def field_max_length = (255 if field_type == 'input_text')

    def field_options = @field['values'] || @field['answer_options']

    def field_type = @field['type']

    def insert_education_questions
      @education_required = @data['education'] == 'education_required'
      core = @fields.first
      core[:questions] = insert_questions(core[:questions], education_questions, :insert_after, :cover_letter)
    end

    def location_question_present? = @data['location_questions'].present?

    def location_questions
      @data['location_questions'].reject do |question|
        question.dig('fields', 0, 'type') == 'input_hidden'
      end
    end

    def option_id(option) = option['value'] || option['id']

    def option_label(option) = option['label']

    def option_free_form(option) = option['free_form']

    def option_decline_to_answer(option) = option['decline_to_answer']

    def question_description = @question['description']

    def question_fields = @question['fields'] || [@question]

    def question_id(question) = question.dig('fields', 0, 'name') || question[:attribute]

    def question_label = @question['label']

    def question_required? = @question['required']
  end
end

EDUCATION_FIELDS = [
  'school',
  'degree',
  'discipline',
  'start_date',
  'end_date'
]

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
    label: 'Location (City)',
    fields: [
      {
        id: 'auto_complete_input',
        selector: 'input[name="job_application[location]"]',
        type: :location,
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
  },
  'school' => {
    attribute: :school_applicant,
    label: 'School',
    description: nil,
    fields: [
      {
        id: 'education_school_name_0',
        selector: 'input[name="job_application[educations][][school_name_id]"]',
        type: :education_select
      }
    ]
  },
  'degree' => {
    attribute: :degree_applicant,
    label: 'Degree',
    description: nil,
    fields: [
      {
        id: 'education_degree_0',
        selector: 'select[name="job_application[educations][][degree_id]"]',
        type: :education_select,
        options: []
      }
    ]
  },
  'discipline' => {
    attribute: :discipline_applicant,
    label: 'Discipline',
    description: nil,
    fields: [
      {
        id: 'education_discipline_0',
        selector: 'select[name="job_application[educations][][discipline_id]"]',
        type: :education_select,
        options: []
      }
    ]
  },
  'start_date' => {
    attribute: :education_start_date_applicant,
    label: 'Start Date',
    description: nil,
    fields: [
      {
        id: nil,
        selector: 'input[name="job_application[educations][][start_date][month]"]',
        type: :education_input,
        max_length: 2,
        options: []
      },
      {
        id: nil,
        selector: 'input[name="job_application[educations][][start_date][year]"]',
        type: :education_input,
        max_length: 4,
        options: []
      }
    ]
  },
  'end_date' => {
    attribute: :education_end_date_applicant,
    label: 'End Date',
    description: nil,
    fields: [
      {
        id: nil,
        selector: 'input[name="job_application[educations][][end_date][month]"]',
        type: :education_input,
        max_length: 2,
        options: []
      },
      {
        id: nil,
        selector: 'input[name="job_application[educations][][end_date][year]"]',
        type: :education_input,
        max_length: 4,
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
  'textarea' => :textarea
}
