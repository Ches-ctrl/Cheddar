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
        core_questions: { title: "Main application", description: nil, questions: @data[:questions] },
        demographic_questions: demographic_formatter(@data.dig(:demographic_questions, :questions)),
        compliance_questions: compliance_formatter(@data[:compliance]),
        location_questions: { title: nil, description: nil, questions: location_formatter(@data[:location_questions]) }
      }
    end

    ###

    def compliance_formatter(compliance_data)
      return {} unless compliance_data

      {
        title: section_attribute_finder(:compliance, :title) || "EEOC compliance questions",
        description: section_attribute_finder(:compliance, :description),
        questions: compliance_questions(compliance_data)
      }
    end

    def compliance_questions(compliance_data)
      compliance_data.map do |section|
        section[:questions].map do |question|
          fields = question[:fields].map do |field|
            { name: field[:name], type: field[:type], values: field[:values] }
          end
          { description: section[:description], label: question[:label], required: question[:required], fields: }
        end
      end.flatten
    end

    def demographic_formatter(demographic_data)
      return {} unless demographic_data

      {
        title: section_attribute_finder(:demographic_questions, :header),
        description: section_attribute_finder(:demographic_questions, :description),
        questions: demographic_questions(demographic_data)
      }
    end

    def demographic_questions(demographic_data)
      demographic_data.map do |question|
        attribute = question[:label].parameterize.underscore.first(50)
        values = question[:answer_options].map { |option| option.transform_keys({ 'id' => 'value' }) }
        fields = [{ name: question[:id], type: question[:type], values: }]
        { attribute:, description: nil, label: question[:label], required: question[:required], fields: }
      end
    end

    def location_formatter(location_data)
      return [] unless location_data.any?

      [{
        attribute: :city_applicant,
        required: false,
        label: "Location (City)",
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

    def section_attribute_finder(section, attribute)
      return nil unless @data[section].present?

      @data.dig(section, attribute)
    end
  end
end
