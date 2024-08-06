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
      # TODO
      # debugger
      # {
      #   core_questions: { title: "Main application", description: nil, questions: core_questions(@data[:formFields].except(:customQuestions)) },
      #   additional_questions: additional_formatter(@data.dig(:formFields, :customQuestions))
      # }
    end

    ###

    def core_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_attribute, raw_question|
        next unless raw_question.present?

        attribute = attribute(raw_attribute)
        options = raw_question[:options]&.map { |option| option.transform_keys({ 'id' => 'value', 'text' => 'label' }) } || []
        type = input_type(attribute, options)
        fields = [{ name: raw_attribute, selector: nil, type:, options: }]
        label = attribute.underscore.humanize

        { attribute:, label:, description: nil, required: raw_question[:isRequired], fields: }
      end.compact
    end

    def additional_formatter(additional_data)
      return {} unless additional_data.present?

      {
        title: 'Additional questions',
        description: nil,
        questions: additional_questions(additional_data)
      }
    end

    def additional_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_question|
        attribute = attribute(raw_question[:question])
        options = raw_question[:options]&.map { |option| option.transform_keys({ 'id' => 'value', 'text' => 'label' }) } || []
        type = INPUT_TYPES[raw_question[:type]]
        fields = [{ name: raw_question[:id], selector: nil, type:, options: }]
        label = raw_question[:question]

        { attribute:, label:, description: nil, required: raw_question[:isRequired], fields: }
      end
    end

    ###
    ### attribute
    ###

    def attribute(raw_attribute)
      attribute_strict_match(raw_attribute) ||
        attribute_inclusive_match(raw_attribute) ||
        default_attribute(raw_attribute)
    end

    def attribute_inclusive_match(key)
      ATTRIBUTES_DICTIONARY.find { |k, _v| default_attribute(key).include?(k) }&.last
    end

    def attribute_strict_match(key)
      ATTRIBUTES_DICTIONARY[key]
    end

    # attribute is CamelCase variable or a Text Question
    def default_attribute(key)
      key.underscore.first(60).gsub(' ', '_').gsub('.', '_')
    end

    ATTRIBUTES_DICTIONARY = {
      'firstName' => 'first_name',
      'lastName' => 'last_name',
      'email' => 'email',
      'streetAddress' => 'address_applicant',
      'city' => 'city_applicant',
      'state' => 'state_applicant',
      'zip' => 'zip_applicant',
      'countryId' => 'country_applicant',
      'phone' => 'phone_number',
      'linkedin' => 'linkedin',
      'coverLetterFileId' => 'cover_letter',
      'resumeFileId' => 'resume',
      'genderId' => 'gender',
      'ethnicityId' => 'ethnicity'
    }

    ###
    ### types
    ###

    def input_type(attribute, options)
      return :upload if %w[resume cover_letter].include?(attribute)

      options.present? ? :select : :input
    end

    INPUT_TYPES = {
      'checkbox' => :boolean,
      'long' => :textarea,
      'short' => :input
    }
  end
end
