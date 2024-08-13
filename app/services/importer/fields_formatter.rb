# frozen_string_literal: true

module Importer
  # TODO
  class FieldsFormatter < ApplicationTask
    def initialize(data)
      p "Here's the raw data:" # for testing
      p data # for testing
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
      log_and_return_data
    end

    def log_and_return_data
      output_file_path = Rails.root.join('public', 'jsons', output_file_name)
      File.write(output_file_path, JSON.pretty_generate(select_transform_data))
      select_transform_data
    end

    def attribute_inclusive_match(key)
      attributes_dictionary.find { |k, _v| default_attribute(key).include?(k) }&.last
    end

    def attribute_strict_match(key)
      attributes_dictionary[key]
    end

    def default_attribute(key)
      key.underscore.parameterize.first(60)
    end

    # We have a deeply nested hash structure and aim to extract all values
    # associated with the key 'attribute' into a new data structure.
    # use : extract_attributes(:attribute, hash)
    def extract_attributes(key, hash)
      result = []

      hash.each do |k, value|
        if k == key
          result << value
        elsif value.is_a?(Hash)
          result.concat(extract_attributes(key, value))
        elsif value.is_a?(Array)
          value.each { |element| result.concat(extract_attributes(key, element)) if element.is_a?(Hash) }
        end
      end

      result
    end
  end
end
