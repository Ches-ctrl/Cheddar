# frozen_string_literal: true

module Importer
  # Core class for getting form fields directly from the API
  # Splits based on category of fields - main, custom, demographic, eeoc
  # Known Issues - Building the checkbox logic for the data_compliance section
  # Allowable file types (Greenhouse): (File types: pdf, doc, docx, txt, rtf)
  # NB. Must include all params to get additional fields from the API
  class GetApiFields < ApplicationTask
    include FaradayHelpers

    def initialize(data, options = {})
      @data = data
      @data_source = options[:data_source]
      @sections = options[:sections] || [:core]
      @standard_fields = options[:standard_fields] || {}
      @types = options[:types] || {}
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

    def add_section_to_fields
      @fields << @section_fields
    end

    def build_fields
      @sections.each do |section|
        generate_section(section)
        build_questions(section)
        add_section_to_fields
      end
    end

    def build_questions(section)
      fetch_questions(section)&.each do |question|
        @question = question
        @section_fields[:questions] << create_question
      end
    end

    def core_details = @standard_fields[question_id] || {}

    def create_question
      {
        attribute: generate_attribute_from_label(question_label),
        required: question_required?,
        label: question_label,
        description: question_description,
        fields: fetch_question_fields
      }.merge(core_details)
    end

    def fetch_question_fields
      question_fields&.map do |field|
        {
          id: field_id(field),
          type: standardize_type(field_type(field)),
          max_length: field_max_length(field),
          options: field_options(field).map do |option|
            {
              id: option_id(option),
              label: option_label(option),
              free_form: option_free_form(option),
              decline_to_answer: option_decline_to_answer(option)
            }.compact
          end
        }.compact
      end
    end

    def fetch_questions(section) = send(:"#{section}_questions")

    def generate_attribute_from_label(label, max_attribute_length = 60)
      first_question_mark = label.index('?')
      max_length = [first_question_mark, max_attribute_length].compact.min
      label.slice(..max_length).downcase.gsub('/', ' ').gsub(/[^a-z ]/, '').strip.gsub(/ +/, '_')
    end

    def generate_section(section)
      @section_fields = {
        build_type: @data_source,
        section_slug: "#{section}_fields",
        title: send(:"#{section}_section_title"),
        description: send(:"#{section}_section_description"),
        questions: []
      }
    end

    def log_and_return_fields
      puts pretty_generate(@fields)
      @fields
    end

    def standardize_type(type)
      @types[type] || type
    end
  end
end
