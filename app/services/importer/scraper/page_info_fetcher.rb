# frozen_string_literal: true

module Importer
  module Scraper
    class PageInfoFetcher < ApplicationTask
      def initialize(url, locator, attribute_to_fetch, _locator_method = :css)
        @doc = fetch_doc(url)
        @locator = locator
        @attribute = attribute_to_fetch
      end

      def call
        return nil unless processable

        process
      end

      private

      def processable
        @doc && @locator && @attribute
      end

      def process
        return unless page_element

        fetch_attribute
      end

      def fetch_attribute = @element[@attribute]

      def fetch_doc(url)
        html = load_page(url) if url
        parse_page(html) if html
      end

      def load_page(url)
        URI.parse(url).open if url
      rescue OpenURI::HTTPError
        nil
      end

      def page_element
        @element = @doc.at_css(@locator)
      rescue
        nil
      end

      def parse_page(html) = Nokogiri::HTML.parse(html)
    end
  end
end
