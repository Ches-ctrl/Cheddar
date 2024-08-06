# frozen_string_literal: true

module Importer
  class GetWorkdayFields < ApplicationTask
    # Some Workday companies require a login cookie to fetch fields
    # If login is required, the API response will include an authentication widget
    # #user_authenticated? checks this and logs in using ENV credentials if required
    # WorkdayCookieFetcher retrieves the cookie, which is attached to the request header
    # Then we make the request again, attaching the cookie
    include FaradayHelpers

    def initialize(api_url)
      @api_url = api_url
      @data = fetch_data_from_api
      @api_url_base = extract_base_url
      @cookie = nil
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
      @cookie = result.map { |cookie| "#{cookie[:name]}=#{cookie[:value]}" }.join('; ')
      @data = fetch_data_from_api
    end

    def authentication_endpoints
      data = authentication_widget
      {
        create_account_url: @api_url_base + data[:createAccountRequestUri],
        sign_in_url: @api_url_base + data[:signInRequestUri],
        target_url: @api_url
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

    def fetch_data_from_api
      faraday_request(request_details)
        &.with_indifferent_access
        &.dig(:body, :children)
    end

    def print_and_return_fields
      puts pretty_generate(@fields)
      @fields
    end

    def request_details(endpoint = @api_url)
      {
        endpoint:,
        options: {
          headers: {
            'Accept' => 'application/json',
            'Cookie' => @cookie
          }
        }
      }
    end

    def sections
      @data
        .find { |section| section[:widget] == 'taskOrchestration' }
        .fetch(:documentGroups)
        .reject { |section| section[:excludedGroup] || section[:name] == 'Autofill with Resume' }
    end

    def user_authenticated?
      authentication_required? ? authenticate : true
    end
  end
end
