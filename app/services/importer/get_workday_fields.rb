# frozen_string_literal: true

module Importer
  class GetWorkdayFields < ApplicationTask
    include FaradayHelpers

    def initialize(api_url)
      @data = fetch_data_from_api(api_url)
      @api_url_base = extract_base_url(api_url)
    end

    def call
      return unless processable

      process
    end

    private

    def processable
      @data && user_authenticated?
    end

    def process
      build_fields
      print_and_return_fields # just for testing
    end

    def authenticate
      p "You need to authenticate"
      false
    end

    def authentication_required?
      @data.any? { |section| section[:widget] == 'authentication' }
    end

    def build_fields
      @fields = sections.map do |section|
        endpoint = @api_url_base + section[:uri]
        puts "fetching section details from #{endpoint}..."
        faraday_request(request_details(endpoint))
          &.with_indifferent_access
          &.dig(:body)
      end
    end

    def extract_base_url(api_url) = URI(api_url).origin

    def fetch_data_from_api(api_url)
      faraday_request(request_details(api_url))
        &.with_indifferent_access
        &.dig(:body, :children)
    end

    def print_and_return_fields
      puts pretty_generate(@fields)
    end

    def request_details(endpoint)
      {
        endpoint:,
        options: {
          headers: {
            'Accept' => 'application/json'
          }
        }
      }
    end

    def sections
      @data
        .find { |section| section[:widget] == 'taskOrchestration' }
        .fetch(:documentGroups)
        .reject { |section| section[:name] == 'Autofill with Resume' }
    end

    def user_authenticated?
      authentication_required? ? authenticate : true
    end
  end
end
