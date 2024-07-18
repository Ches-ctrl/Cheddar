# frozen_string_literal: true

module Importer
  module Scraper
    class TrueUpBuildVersionFetcher < ApplicationTask
      # Check periodically this isn't running into captcha and getting 403'd...

      def initialize
        @url = "https://www.trueup.io/"
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

        parse_build_version
      end

      def page_script
        html = URI.parse(@url).open
        doc = Nokogiri::HTML(html)
        @page_script = doc.at_css('script[src^="/_next/static/"][src$="_buildManifest.js"]')
      end

      def parse_build_version
        match = @page_script['src'].match(%r{/_next/static/(.+?)/_buildManifest\.js})
        match[1] if match
      end
    end
  end
end
