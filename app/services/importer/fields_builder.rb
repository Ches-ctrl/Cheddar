# frozen_string_literal: true

module Importer
  # This service object builds a structured representation of job application fields based on pre-formatted Greenhouse data.
  # It relies on the `GreenhouseFieldsFormatter` to prepare the raw data and then constructs a list of field sections.
  # Each section includes details like title, description, build type (API in this case), and individual questions.
  # Question details incorporate attributes, labels, descriptions, required status, and associated field objects.
  # The output of this service is used to the job associated application_question_set.

  class FieldsBuilder < ApplicationTask
    include FaradayHelpers

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
      build_fields
      log_and_return_fields
    end

    ###

    def build_fields
      @fields = @data.map do |section_sym, section_data|
        {
          build_type:,
          section_slug: section_sym,
          title: section_data[:title],
          description: section_data[:description],
          questions: questions_builder(section_data[:questions])
        }
      end
    end

    # TODO : change especially if application_question_set becomes hash (instead of array)
    def build_type = :api

    def log_and_return_fields
      # puts pretty_generate(@fields)
      @fields
    end

    def questions_builder(section)
      return [] unless section.present?

      section.map { |question| question_params(question) if question.present? }
    end

    def question_params(question)
      {
        attribute: question[:fields].first[:name],
        description: question[:description],
        label: question[:label],
        required: question[:required],
        fields: question[:fields]
      }
    end
  end
end
