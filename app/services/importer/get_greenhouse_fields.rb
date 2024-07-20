# frozen_string_literal: true

module Importer
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

    def convert_to_numerical_id(value) = value.is_a?(String) && value =~ /question_(\d+)/ ? ::Regexp.last_match(1) : value

    def core_questions
      questions = @data['questions']
      insert_questions(questions, location_questions, :insert_before, 'resume') if location_question_present?
    end

    def demographic_questions = @data.dig('demographic_questions', 'questions')

    def demographic_section_description = @data.dig('demographic_questions', 'description')

    def demographic_section_title = @data.dig('demographic_questions', 'header')

    def education_question_present? = @data['education'].present?

    def education_questions
      [school_question] + [
        'degree',
        'discipline',
        'start_date',
        'end_date'
      ].map { |question| @standard_fields[question].merge(required: @education_required) }
    end

    def field_id(field) = convert_to_numerical_id(field['name'] || field['id'])

    def field_max_length(field) = (255 if field_type(field) == 'input_text')

    def field_options(field) = field['values'] || field['answer_options']

    def field_type(field) = field['type']

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

    def school_question
      question = @standard_fields['school'].merge(required: @education_required)
      question[:fields][0][:options] = Importer::GreenhouseSchoolOptionsFetcher.call(@company_id)
      question
    end
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
        options: [
          {
            id: '5169801',
            label: 'High School'
          },
          {
            id: '5169824',
            label: "Associate's Degree"
          },
          {
            id: '5169916',
            label: "Bachelor's Degree"
          },
          {
            id: '5169936',
            label: "Master's Degree"
          },
          {
            id: '5170011',
            label: 'Master of Business Administration (M.B.A.)'
          },
          {
            id: '5170126',
            label: 'Juris Doctor (J.D.)'
          },
          {
            id: '5170145',
            label: 'Doctor of Medicine (M.D.)'
          },
          {
            id: '5170169',
            label: 'Doctor of Philosophy (Ph.D.)'
          },
          {
            id: '5170188',
            label: "Engineer's Degree"
          },
          {
            id: '5170208',
            label: 'Other'
          }
        ]
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
        options: [
          {
            id: '5170311',
            label: 'Accounting'
          },
          {
            id: '5170332',
            label: 'African Studies'
          },
          {
            id: '5170353',
            label: 'Agriculture'
          },
          {
            id: '5170380',
            label: 'Anthropology'
          },
          {
            id: '5170405',
            label: 'Applied Health Services'
          },
          {
            id: '5170446',
            label: 'Architecture'
          },
          {
            id: '5170468',
            label: 'Art'
          },
          {
            id: '5170514',
            label: 'Asian Studies'
          },
          {
            id: '5170576',
            label: 'Biology'
          },
          {
            id: '5170607',
            label: 'Business'
          },
          {
            id: '5170636',
            label: 'Business Administration'
          },
          {
            id: '5170662',
            label: 'Chemistry'
          },
          {
            id: '5170689',
            label: 'Classical Languages'
          },
          {
            id: '5170718',
            label: 'Communications & Film'
          },
          {
            id: '5170743',
            label: 'Computer Science'
          },
          {
            id: '5170772',
            label: 'Dentistry'
          },
          {
            id: '5170800',
            label: 'Developing Nations'
          },
          {
            id: '5170830',
            label: 'Discipline Unknown'
          },
          {
            id: '5170859',
            label: 'Earth Sciences'
          },
          {
            id: '5170895',
            label: 'Economics'
          },
          {
            id: '5170922',
            label: 'Education'
          },
          {
            id: '5170947',
            label: 'Electronics'
          },
          {
            id: '5170975',
            label: 'Engineering'
          },
          {
            id: '5171006',
            label: 'English Studies'
          },
          {
            id: '5171035',
            label: 'Environmental Studies'
          },
          {
            id: '5171067',
            label: 'European Studies'
          },
          {
            id: '5171093',
            label: 'Fashion'
          },
          {
            id: '5171123',
            label: 'Finance'
          },
          {
            id: '5171155',
            label: 'Fine Arts'
          },
          {
            id: '5171187',
            label: 'General Studies'
          },
          {
            id: '5171219',
            label: 'Health Services'
          },
          {
            id: '5171250',
            label: 'History'
          },
          {
            id: '5171281',
            label: 'Human Resources Management'
          },
          {
            id: '5171313',
            label: 'Humanities'
          },
          {
            id: '5171345',
            label: 'Industrial Arts & Carpentry'
          },
          {
            id: '5171375',
            label: 'Information Systems'
          },
          {
            id: '5171406',
            label: 'International Relations'
          },
          {
            id: '5171446',
            label: 'Journalism'
          },
          {
            id: '5171473',
            label: 'Languages'
          },
          {
            id: '5171506',
            label: 'Latin American Studies'
          },
          {
            id: '5171541',
            label: 'Law'
          },
          {
            id: '5171574',
            label: 'Linguistics'
          },
          {
            id: '5171604',
            label: 'Manufacturing & Mechanics'
          },
          {
            id: '5171632',
            label: 'Mathematics'
          },
          {
            id: '5171667',
            label: 'Medicine'
          },
          {
            id: '5171704',
            label: 'Middle Eastern Studies'
          },
          {
            id: '5171737',
            label: 'Naval Science'
          },
          {
            id: '5171769',
            label: 'North American Studies'
          },
          {
            id: '5171803',
            label: 'Nuclear Technics'
          },
          {
            id: '5171835',
            label: 'Operations Research & Strategy'
          },
          {
            id: '5171880',
            label: 'Organizational Theory'
          },
          {
            id: '5171913',
            label: 'Philosophy'
          },
          {
            id: '5171948',
            label: 'Physical Education'
          },
          {
            id: '5171970',
            label: 'Physical Sciences'
          },
          {
            id: '5171993',
            label: 'Physics'
          },
          {
            id: '5172016',
            label: 'Political Science'
          },
          {
            id: '5172043',
            label: 'Psychology'
          },
          {
            id: '5172069',
            label: 'Public Policy'
          },
          {
            id: '5172094',
            label: 'Public Service'
          },
          {
            id: '5172117',
            label: 'Religious Studies'
          },
          {
            id: '5172141',
            label: 'Russian & Soviet Studies'
          },
          {
            id: '5172163',
            label: 'Scandinavian Studies'
          },
          {
            id: '5172193',
            label: 'Science'
          },
          {
            id: '5172223',
            label: 'Slavic Studies'
          },
          {
            id: '5172252',
            label: 'Social Science'
          },
          {
            id: '5172285',
            label: 'Social Sciences'
          },
          {
            id: '5172315',
            label: 'Sociology'
          },
          {
            id: '5172343',
            label: 'Speech'
          },
          {
            id: '5172373',
            label: 'Statistics & Decision Theory'
          },
          {
            id: '5172402',
            label: 'Urban Studies'
          },
          {
            id: '5172435',
            label: 'Veterinary Medicine'
          },
          {
            id: '13011758',
            label: 'Other'
          }
        ]
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
  'textarea' => :input
}
