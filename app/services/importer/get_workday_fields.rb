# frozen_string_literal: true

module Importer
  class GetWorkdayFields < ApplicationTask
    include FaradayHelpers

    def initialize(api_url)
      @api_url = api_url
      @data = fetch_data_from_api
      @api_url_base = extract_base_url
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
      result = Importer::Scraper::WorkdayCookieFetcher.call(authentication_endpoints)
      cookie = result.map { |cookie| "#{cookie[:name]}=#{cookie[:value]}" }.join('; ')
      p "Here's the cookie: #{cookie}"
      @data = fetch_data_from_api(cookie)
    end

    def authentication_endpoints
      data = authentication_widget
      {
        sign_in_url: @api_url_base + data[:signInRequestUri],
        create_account_url: @api_url_base + data[:createAccountRequestUri]
      }
    end

    def authentication_required? = authentication_widget.present?

    def authentication_widget = @data.find { |section| section[:widget] == 'authentication' }

    def build_fields
      @fields = sections.map do |section|
        endpoint = @api_url_base + section[:uri]
        puts "fetching section details from #{endpoint}..."
        faraday_request(request_details(endpoint))
          &.with_indifferent_access
          &.dig(:body)
      end
    end

    def extract_base_url = URI(@api_url).origin

    def fetch_data_from_api(cookie = nil)
      faraday_request(request_details(cookie))
        &.with_indifferent_access
        &.dig(:body, :children)
    end

    def print_and_return_fields
      puts pretty_generate(@fields)
    end

    def request_details(cookie)
      {
        endpoint: @api_url,
        options: {
          headers: {
            'Accept' => 'application/json',
            'Cookie' => cookie
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
