# frozen_string_literal: true

module Importer
  class GreenhouseEducationOptionsFetcher < ApplicationTask
    include FaradayHelpers

    def initialize(company_id, type)
      @type = type
      @endpoint = "https://boards-api.greenhouse.io/v1/boards/#{company_id}/education/#{@type}s"
    end

    def call
      return [] unless processable

      process
    end

    private

    def processable
      processable_types.include?(@type)
    end

    def process
      fetch_meta_data
      fetch_all_results
      parse_data
    end

    def extract(data) = data&.dig('items')

    def fetch_meta_data
      @data, @total_count, @per_page = initial_request
    end

    def fetch_all_results
      additional_pages = @total_count / @per_page
      additional_pages.times do |i|
        @page = i + 2
        @data += extract faraday_request(endpoint: @endpoint, options: request_options)
      end
    end

    def initial_request
      response = fetch_json(@endpoint)

      [
        extract(response),
        response&.dig('meta', 'total_count'),
        response&.dig('meta', 'per_page')
      ]
    end

    def parse_data
      @data.map do |option|
        {
          id: option['id'].to_s,
          label: option['text']
        }
      end
    end

    def processable_types = ['school', 'degree', 'discipline']

    def request_options
      {
        params: {
          page: @page
        }
      }
    end
  end
end
