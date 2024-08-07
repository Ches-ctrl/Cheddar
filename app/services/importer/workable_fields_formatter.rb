# frozen_string_literal: true

module Importer
  class WorkableFieldsFormatter < ApplicationTask
    def initialize(data)
      @data = data
    end

    def call
      return [] unless processable

      process
    end

    private

    def select_transform_data
      {
        core_questions: { title: "Main application", description: nil, questions: any_questions(@data.except('Details').map { |_k, hash| hash[:fields] }.flatten) },
        additional_questions: additional_formatter(@data.dig(:Details, :fields))
      }
    end

    ###

    def any_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_question|
        attribute = raw_question[:id]
        options = raw_question[:options]&.map { |option| option.transform_keys({ 'id' => 'value', 'value' => 'label' }) } || []
        type = INPUT_TYPES[raw_question[:type]]
        fields = [{ name: attribute, selector: nil, type:, options: }]
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

    def attribute_strict_match(key)
      ATTRIBUTES_DICTIONARY[key]
    end

    # attribute is CamelCase variable or a Text Question
    def default_attribute(key)
      key.underscore.first(60).gsub(' ', '_').gsub('.', '_')
    end

    ATTRIBUTES_DICTIONARY = {
      'firstname' => 'first_name',
      'lastname' => 'last_name',
      'gdpr' => 'gdpr',
      'email' => 'email',
      'phone' => 'phone_number',
      'address' => 'address_applicant',
      'resume' => 'resume',
      'cover_letter' => 'cover_letter'
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
