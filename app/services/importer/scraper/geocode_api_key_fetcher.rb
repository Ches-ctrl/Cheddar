# frozen_string_literal: true

module Importer
  module Scraper
    class GeocodeApiKeyFetcher < ApplicationTask
      # Check periodically this isn't running into captcha and getting 403'd...

      def initialize
        @url = "https://boards.greenhouse.io/gomotive/jobs/7082961002#app"
      end

      def call
        return false unless processable

        process
      end

      private

      def processable
        true
      end

      def process
        return unless page_script

        parse_api_key
      end

      def page_script
        html = URI.parse(@url).open
        doc = Nokogiri::HTML(html)
        @page_script = doc.at_css('script[data-key="LocationControl.Providers.Pelias.apiKey"]')
      end

      def parse_api_key
        @page_script['data-value']
      end
    end
  end
end
