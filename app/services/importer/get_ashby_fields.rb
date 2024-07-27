# frozen_string_literal: true

module Importer
  # Calls the base API class with options specific to the ATS
  # Options are a fixed list limited to the below
  # One-line methods are mostly for matching the generic structure to the particular API structure
  # Ashby has always 1x ApplicationForm (JSON) and can have many SurveyForms (Array)
  # StandardFields replaces the ID with our structure of JSON fields for each of the StandardFields found
  # TYPES maps the Ashby field types to our standard field types
  class GetAshbyFields < GetApiFields
    def initialize(job, data)
      options = {
        data_source: :api,
        sections: %i[core survey],
        standard_fields: STANDARD_FIELDS,
        types: TYPES
      }
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

    def field_id = @field['path']

    def field_max_length = nil

    def field_options = @field['selectableValues'] || []

    def field_type = @field['type']

    def form_section = FORM_SECTIONS[@section]

    def number_of_subsections = @data[form_section].size

    def option_decline_to_answer(_option) = nil

    def option_free_form(_option) = nil

    def option_id(_option) = "input[id$='#{field_id}-labeled-radio-#{@option_index}']"

    def option_label(option) = option['label']

    def question_description = @question['descriptionHtml']

    def question_fields = [@question['field']]

    def question_id(question) = question.dig('field', 'path')

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
      },
      '_systemfield_location' => {
        attribute: :location,
        fields: [
          {
            id: '_systemfield_location',
            selector: nil,
            type: :location,
            options: []
          }
        ]
      },
      '_systemfield_resume' => {
        attribute: :resume,
        fields: [
          {
            id: '_systemfield_resume',
            selector: nil,
            type: :upload,
            options: []
          }
        ]
      },
      '_systemfield_eeoc_gender' => {
        attribute: :gender,
        fields: [
          {
            id: '_systemfield_eeoc_gender',
            selector: nil,
            type: :select,
            options: []
          }
        ]
      },
      '_systemfield_eeoc_race' => {
        attribute: :race,
        fields: [
          {
            id: '_systemfield_eeoc_race',
            selector: nil,
            type: :select,
            options: []
          }
        ]
      },
      '_systemfield_eeoc_veteran_status' => {
        attribute: :veteran_status,
        fields: [
          {
            id: '_systemfield_eeoc_veteran_status',
            selector: nil,
            type: :select,
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
      'LongText' => :textarea,
      'ValueSelect' => :select,
      'MultiValueSelect' => :multi_select,
      'Phone' => :input,
      'Score' => :input,
      'SocialLink' => :input
    }
  end
end
