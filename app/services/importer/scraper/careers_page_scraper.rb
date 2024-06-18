module Importer
  module Scraper
    class CareersPageScraper
      include CheckUrlIsValid

      def initialize(attributes)
        @url = attributes[:url]
        @locator = attributes[:locator]
      end

      def scrape
        html = get(@url)
        return unless html

        doc = Nokogiri::HTML.parse(html)
        doc.at_xpath(@locator)
      end
    end
  end
end
