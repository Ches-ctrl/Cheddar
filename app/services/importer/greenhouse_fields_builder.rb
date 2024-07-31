# frozen_string_literal: true

# This service object builds a structured representation of job application fields based on pre-formatted Greenhouse data.
# It relies on the `GreenhouseFieldsFormatter` to prepare the raw data and then constructs a list of field sections.
# Each section includes details like title, description, build type (API in this case), and individual questions.
# Question details incorporate attributes, labels, descriptions, required status, and associated field objects.
# The output of this service is used to the job associated application_question_set.

module Importer
  class GreenhouseFieldsBuilder < ApplicationTask
    include FaradayHelpers

    def initialize(data)
      @data = Importer::GreenhouseFieldsFormatter.call(data.with_indifferent_access)
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
      build_fields
      log_and_return_fields
    end

    ###

    def build_fields
      @fields = [
        {
          build_type: :api,
          section_slug: "core_fields",
          title: "Main application",
          description: nil,
          questions: questions_builder(@data.dig(:core_questions, :questions))
        },
        {
          build_type: :api,
          section_slug: "demographic_fields",
          title: @data.dig(:demographic_questions, :title),
          description: @data.dig(:demographic_questions, :description),
          questions: questions_builder(@data.dig(:demographic_questions, :questions))
        },
        {
          build_type: :api,
          section_slug: "compliance_fields",
          title: @data.dig(:compliance_questions, :title),
          description: @data.dig(:compliance_questions, :description),
          questions: questions_builder(@data.dig(:compliance_questions, :questions))
        }
      ]
    end

    def log_and_return_fields
      puts pretty_generate(@fields)
      @fields
    end

    def questions_builder(section)
      return [] unless section.present?

      section.map { |question| question_params(question) if question.present? }
    end

    def question_params(question)
      { attribute: question[:fields].first[:name],
        description: question[:description],
        label: question[:label],
        required: question[:required],
        fields: question[:fields] }
    end
  end
end
