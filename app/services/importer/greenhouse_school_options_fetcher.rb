# frozen_string_literal: true

module Importer
  class GreenhouseSchoolOptionsFetcher < ApplicationTask
    include FaradayHelpers

    def initialize(company_id)
      endpoint = "https://boards-api.greenhouse.io/v1/boards/#{company_id}/education/schools"
      @data = fetch_json(endpoint)&.dig('items')
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
      @data.map do |option|
        {
          id: option['id'].to_s,
          label: option['text']
        }
      end
    end
  end
end
