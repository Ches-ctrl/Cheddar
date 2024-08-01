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
    def initialize(job, data)
      @job = job
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
        survey_questions: survey_formatter(@data[:surveyForms].first[:sections])
      }
    end

    ###

    def any_questions(core_data)
      return {} unless core_data

      core_data.map do |raw_question|
        type = INPUT_TYPES[raw_question.dig(:field, :type)]
        fields = [{ name: raw_question.dig(:field, :path), selector: nil, type:, values: [] }]
        label = raw_question.dig(:field, :title) || raw_question.dig(:field, :humanReadablePath)

        { description: nil, label:, required: raw_question[:isRequired], fields: }
      end
    end

    def survey_formatter(survey_data)
      return {} unless survey_data

      {
        title: survey_data.first[:title],
        description: survey_data.first[:descriptionHtml],
        questions: any_questions(survey_data.first[:fieldEntries])
      }
    end

    def survey_questions(survey_data)
      survey_data.map do |question|
        attribute = question[:label].parameterize.underscore.first(50)
        values = question[:answer_options].map { |option| option.transform_keys({ 'id' => 'value' }) }
        fields = [{ name: question[:id], type: question[:type], values: }]
        { attribute:, description: nil, label: question[:label], required: question[:required], fields: }
      end
    end

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
