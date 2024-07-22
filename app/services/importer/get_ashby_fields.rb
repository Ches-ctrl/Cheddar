# frozen_string_literal: true

module Importer
  class GetAshbyFields < GetApiFields
    def initialize(job, data)
      options = {
        data_source: :api,
        sections: %i[core survey],
        standard_fields: STANDARD_FIELDS,
        types: TYPES
      }
      @section_index = nil

      super(job, data, options)
    end

    private

    def build_fields
      @sections.each do |section|
        @section = section
        contains_subsections? ? build_subsections : build_section
      end
    end

    def build_section(index = nil)
      section_part_data(index)
        .reject { |section| section['isHidden'] }
        .each do |data|
          @section_data = data
          super()
        end
    end

    def build_subsections = number_of_subsections.times { |i| build_section(i) }

    def contains_subsections? = @data[form_section].is_a?(Array)

    def core_data = @data.dig('applicationForm', 'sections')

    def core_questions = fetch_questions

    def fetch_questions = @section_data['fieldEntries']

    def field_id(field) = field['path']

    def field_max_length(_field) = nil

    def field_options(field) = field['selectableValues'] || []

    def field_type(field) = field['type']

    def form_section = FORM_SECTIONS[@section]

    def number_of_subsections = @data[form_section].size

    def option_decline_to_answer(_option) = nil

    def option_free_form(_option) = nil

    def option_id(option) = option['value']

    def option_label(option) = option['label']

    def question_description = @question['descriptionHtml']

    def question_fields = [@question['field']]

    def question_id(question) = question.dig('field', 'path') || question[:attribute]

    def question_label = @question.dig('field', 'title')

    def question_required? = @question['isRequired']

    def section_part_data(index) = index ? @data.dig(form_section, index, 'sections') : @data.dig(form_section, 'sections')

    def survey_questions = fetch_questions

    def survey_section_title = @section_data['title']

    def survey_section_description = @section_data['descriptionHtml']

    FORM_SECTIONS = {
      core: 'applicationForm',
      survey: 'surveyForms'
    }

    STANDARD_FIELDS = {
      '_systemfield_name' => {
        attribute: :full_name,
        fields: [
          {
            id: '_systemfield_name',
            selector: nil,
            type: :input,
            options: []
          }
        ]
      },
      '_systemfield_email' => {
        attribute: :email,
        fields: [
          {
            id: '_systemfield_email',
            selector: nil,
            type: :input,
            options: []
          }
        ]
      }
    }

    TYPES = {
      'String' => :input,
      'Email' => :input,
      'File' => :upload,
      'Date' => :date,
      'Number' => :number,
      'Boolean' => :boolean,
      'Location' => :location,
      'LongText' => :textbox,
      'ValueSelect' => :select,
      'MultiValueSelect' => :multi_select,
      'Phone' => :input,
      'Score' => :input,
      'SocialLink' => :input
    }
  end
end
