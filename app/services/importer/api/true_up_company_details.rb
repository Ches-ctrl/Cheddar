# frozen_string_literal: true

module Importer
  module Api
    class TrueUpCompanyDetails < ApplicationTask
      include FaradayHelpers

      def initialize(ats_identifier)
        @ats_identifier = ats_identifier
        @hash = fetch_build_version
        @url = "https://www.trueup.io/_next/data/#{@hash}/co/#{@ats_identifier}.json"
      end

      def call
        return false unless processable

        process
      end

      private

      def processable
        @ats_identifier && @hash
      end

      def process
        fetch_company_data
        parse_data
      end

      def fetch_build_version
        Rails.cache.fetch('true_up_build_hash', expires_in: 2.hours) { Importer::Scraper::TrueUpBuildVersionFetcher.call }
      end

      def fetch_company_data
        puts "fetching company data from #{@url}..."
        @data = faraday_request(endpoint: @url, options:)
      end

      def headers
        {
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:128.0) Gecko/20100101 Firefox/128.0',
          'Host' => 'www.trueup.io',
          'Accept' => 'application/json',
          'Accept-Language' => 'en-US,en;q=0.5',
          'Referer' => 'https://www.trueup.io/myjobs',
          'x-nextjs-data' => '1',
          'Alt-Used' => 'www.trueup.io',
          'Connection' => 'keep-alive',
          'Sec-Fetch-Dest' => 'empty',
          'Sec-Fetch-Mode' => 'cors',
          'Sec-Fetch-Site' => 'same-origin',
          'Priority' => 'u=0',
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      end

      def options = { headers: }

      def parse_data = @data&.dig('pageProps', 'companyInfo')
    end
  end
end
