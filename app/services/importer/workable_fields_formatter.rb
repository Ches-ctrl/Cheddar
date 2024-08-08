# frozen_string_literal: true

module Importer
  # This service object is responsible for formatting data received from Workable, into a structured format suitable for our application.
  # It extracts specific sections (core questions and Details) and transforms them into a standardized format.
  # The output of this service is used by fields_builder.

  class WorkableFieldsFormatter < FieldsFormatter
    private

    def select_transform_data
      @select_transform_data ||= {
        core_questions: { title: "Main application", description: nil, questions: any_questions(@data.except('Details').map { |_k, hash| hash[:fields] }.flatten) },
        additional_questions: additional_formatter(@data.dig(:Details, :fields))
      }
    end

    ###

    def any_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_question|
        attribute = attribute(raw_question[:id])
        options = raw_question[:options]&.map { |option| option.transform_keys({ 'value' => 'label' }) }&.map { |option| option.transform_keys({ 'name' => 'value' }) } || []

        type = INPUT_TYPES[raw_question[:type]]
        fields = [{ name: raw_question[:id], selector: nil, type:, options: }]
        label = raw_question[:label]

        { attribute:, label:, description: nil, required: raw_question[:required], fields: }
      end.compact
    end

    def additional_formatter(additional_data)
      return {} unless additional_data.present?

      {
        title: 'Additional questions',
        description: nil,
        questions: any_questions(additional_data)
      }
    end

    ###
    ### attribute
    ###

    def attribute(raw_attribute)
      attribute_strict_match(raw_attribute) ||
        default_attribute(raw_attribute)
    end

    ATTRIBUTES_DICTIONARY = {
      'address' => 'address_applicant',
      'avatar' => 'photo',
      'cover_letter' => 'cover_letter',
      'email' => 'email',
      'firstname' => 'first_name',
      'gdpr' => 'gdpr',
      'lastname' => 'last_name',
      'phone' => 'phone_number',
      'resume' => 'resume'
    }

    ###
    ### types
    ###

    INPUT_TYPES = {
      'boolean' => :boolean,
      'date' => :date,
      'dropdown' => :select,
      'email' => :input,
      'file' => :upload,
      'multiple' => :multi_select,
      'paragraph' => :textarea,
      'phone' => :input,
      'text' => :input
    }

    def output_file_name = 'workable_formatter_output.json'
  end
end
