# frozen_string_literal: true

module Importer
  # This service object is responsible for formatting Greenhouse data into a structured format suitable for our application.
  # It extracts specific sections (core questions, demographics, compliance, location) from the raw data and transforms them into a standardized format.
  # The output of this service is used by fields_builder.

  # Key functionalities:
  # - Extracts core questions directly from the raw data.
  # - Formats demographic and compliance questions with title, description, and transformed questions.
  # - Creates a location question with auto-complete input for city.
  class GreenhouseFieldsFormatter < ApplicationTask
    def initialize(data)
      @data = data
    end

    def call
      return unless processable

      process
    end

    private

    def processable
      @data
    end

    def process
      select_transform_data
    end

    def select_transform_data
      {
        core_questions: { title: "Main application", description: nil, questions: core_questions(@data[:questions]) },
        demographic_questions: demographic_formatter(@data.dig(:demographic_questions, :questions)),
        compliance_questions: compliance_formatter(@data[:compliance]),
        location_questions: { title: nil, description: nil, questions: location_formatter(@data[:location_questions]) }
      }
    end

    ###

    def compliance_formatter(compliance_data)
      return {} unless compliance_data

      {
        title: "EEOC compliance questions",
        description: compliance_data.first[:description],
        questions: compliance_questions(compliance_data)
      }
    end

    def compliance_questions(compliance_data)
      compliance_data.map do |section|
        section[:questions].map do |question|
          fields = question[:fields].map do |field|
            { name: field[:name], type: INPUT_TYPES[field[:type]], options: field[:values] }
          end
          attribute = attribute(question)
          { attribute:, label: question[:label], description: section[:description], required: question[:required], fields: }
        end
      end.flatten
    end

    def core_questions(core_data)
      core_data.each do |question|
        question.deep_transform_keys! do |key|
          key == 'values' ? 'options' : key
        end
        question[:attribute] = attribute(question)
        question[:fields].each { |field| field[:type] = INPUT_TYPES[field[:type]] }
      end
    end

    def demographic_formatter(demographic_data)
      return {} unless demographic_data

      {
        title: @data.dig(:demographic_questions, :header),
        description: @data.dig(:demographic_questions, :description),
        questions: demographic_questions(demographic_data)
      }
    end

    def demographic_questions(demographic_data)
      demographic_data.map do |question|
        attribute = attribute(question)
        options = question[:answer_options].map { |option| option.transform_keys({ 'id' => 'value' }) }
        fields = [{ name: question[:id], type: INPUT_TYPES[question[:type]], options: }]
        { attribute:, label: question[:label], description: nil, required: question[:required], fields: }
      end
    end

    def location_formatter(location_data)
      return [] unless location_data.any?

      [{
        attribute: 'city_applicant',
        required: false,
        label: "Location (City))",
        description: nil,
        fields: [{
          id: "auto_complete_input",
          selector: "input[name=\"job_application[location]\"]",
          type: :location,
          max_length: 255,
          options: []
        }]
      }]
    end

    ###
    ### attribute
    ###

    def attribute(question)
      (attribute_strict_match(question[:fields].first[:name]) unless question[:fields].nil?) ||
        attribute_strict_match(question[:label].parameterize.underscore.first(60)) ||
        attribute_inclusive_match(question) ||
        default_attribute(question)
    end

    def attribute_inclusive_match(question)
      ATTRIBUTES_DICTIONARY.find { |k, _v| default_attribute(question).include?(k) }&.last
    end

    def attribute_strict_match(key)
      ATTRIBUTES_DICTIONARY[key]
    end

    def default_attribute(question)
      question[:label].parameterize.underscore.first(60)
    end

    ATTRIBUTES_DICTIONARY = {
      'email' => 'email',
      'location' => 'location',
      'resume' => 'resume',
      'phone' => 'phone_number',
      'linkedin' => 'linkedin',
      'cover_letter' => 'cover_letter'
    }

    ###
    ### types
    ###

    INPUT_TYPES = {
      'input_file' => :upload,
      'input_text' => :input,
      'multi_value_multi_select' => :multi_select,
      'multi_value_single_select' => :select,
      'textarea' => :textarea
    }
  end
end
