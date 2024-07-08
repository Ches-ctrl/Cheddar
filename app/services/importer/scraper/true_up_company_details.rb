# frozen_string_literal: true

module Importer
  module Scraper
    class TrueUpCompanyDetails < ApplicationTask
      def initialize(ats_identifier)
        @url = "https://www.trueup.io/co/#{ats_identifier}"
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
        return {} unless page_script

        parse_company_data_from_script
      end

      def page_script
        html = URI.parse(@url).open
        doc = Nokogiri::HTML(html)
        @page_script = doc.at_css('script#__NEXT_DATA__')
      end

      def parse_company_data_from_script
        result = @page_script.content.strip
        data = JSON.parse(result)
        data&.dig('props', 'pageProps', 'companyInfo')
      end
    end
  end
end
