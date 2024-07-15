# frozen_string_literal: true

module Importer
  # Core class for getting form fields directly from the API
  # Splits based on category of fields - main, custom, demographic, eeoc
  # Known Issues - Building the checkbox logic for the data_compliance section
  # Allowable file types (Greenhouse): (File types: pdf, doc, docx, txt, rtf)
  # NB. Must include all params to get additional fields from the API
  class GetApiFields < ApplicationTask
    include FaradayHelpers

    def initialize(data, data_source = nil, sections = [:core])
      @data = data
      @data_source = data_source
      @sections = sections
      @fields = []
      @errors = false
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

    def add_section_to_fields(section)
      @fields << instance_variable_get("@#{section}_fields")
    end

    def build_fields
      @sections.each do |section|
        send(:"generate_#{section}_fields")
        send(:"fetch_#{section}_questions")
        add_section_to_fields(section)
      end
    end

    def fetch_core_questions
      core_questions&.each { |question| @core_fields[:questions] << create_question(question) }
    end

    def generate_core_fields
      @core_fields = {
        data_source: @data_source,
        section_slug: 'core_fields',
        title: 'Main application',
        description: nil,
        questions: []
      }
    end

    def log_and_return_fields
      puts pretty_generate(@fields)
      @fields
    end
  end
end
