# frozen_string_literal: true

module Importer
  # This service object is responsible for formatting data received from Ashbyhq, another recruiting platform, into a structured format suitable for our application.
  # It extracts specific sections (core questions and surveys) and transforms them into a standardized format.
  # The output of this service is used by fields_builder.

  # Key functionalities:
  # - Extracts core questions from the first section of `applicationForm`.
  # - Extracts survey questions from the first section of the first `surveyForm`.
  # - Applies specific formatting rules for both question types:
  #   - Extracts label, description, and required status.
  #   - Maps field types from Ashbyhq to internal application types (using INPUT_TYPES constant).
  #   - Builds question fields with name, selector (optional), type, and values (if applicable).

  class AshbyhqFieldsFormatter < ApplicationTask
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
        core_questions: { title: "Main application", description: nil, questions: any_questions(@data.dig(:applicationForm, :sections).first[:fieldEntries]) },
        survey_questions: survey_formatter(@data[:surveyForms])
      }
    end

    ###

    def any_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_question|
        attribute = attribute(raw_question)
        type = INPUT_TYPES[raw_question.dig(:field, :type)]
        options = raw_question.dig(:field, :selectableValues) || []
        fields = [{ name: raw_question.dig(:field, :path), selector: nil, type:, options: }]
        label = raw_question.dig(:field, :title) || raw_question.dig(:field, :humanReadablePath)

        { attribute:, label:, description: nil, required: raw_question[:isRequired], fields: }
      end
    end

    def survey_formatter(survey_data)
      return {} unless survey_data.any?

      survey_data = survey_data.first[:sections]
      {
        title: survey_data.first[:title],
        description: survey_data.first[:descriptionHtml],
        questions: any_questions(survey_data.first[:fieldEntries])
      }
    end

    ###
    ### attribute
    ###

    def attribute(question)
      attribute_strict_match(question[:field][:path]) ||
        attribute_strict_match(question[:field][:type]) ||
        attribute_strict_match(question[:field][:title].parameterize.underscore.first(60)) ||
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
      question[:field][:title].parameterize.underscore.first(60)
    end

    ATTRIBUTES_DICTIONARY = {
      '_systemfield_name' => 'full_name',
      '_systemfield_email' => 'email',
      '_systemfield_location' => 'location',
      '_systemfield_resume' => 'resume',
      '_systemfield_eeoc_gender' => 'gender',
      '_systemfield_eeoc_race' => 'race',
      '_systemfield_eeoc_veteran_status' => 'veteran_status',
      'phone' => 'phone_number',
      'linkedin' => 'linkedin',
      'cover_letter' => 'cover_letter'
    }

    ###
    ### types
    ###

    INPUT_TYPES = {
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
