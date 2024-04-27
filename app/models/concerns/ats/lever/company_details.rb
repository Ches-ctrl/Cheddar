module Ats
  module Lever
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api = "#{url_api}#{ats_identifier}/?mode=json"
        url_ats_main = "#{url_base}#{ats_identifier}"
        name, url_website = scrape_company_page(url_ats_main)
        data = get_json_data(url_ats_api)
        {
          name:,
          description: data.dig(0, 'additionalPlain'),
          url_ats_api:,
          url_ats_main:,
          url_website:
        }
      end

      def scrape_company_page(url_ats_main)
        html = URI.parse(url_ats_main).open
        doc = Nokogiri::HTML.parse(html)
        element = doc.xpath('//div[contains(@class, "main-footer-text page-centered")]//a').first
        [element.text.sub(' Home Page', ''), element['href']]
      end
    end
  end
end
