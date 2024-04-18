module Ats
  module Lever
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api = "#{base_url_api}#{ats_identifier}/?mode=json"
        url_ats_main = "#{base_url_main}#{ats_identifier}"
        company_name, company_website_url = scrape_company_page(url_ats_main)
        response = get(url_ats_api)
        data = JSON.parse(response)
        {
          company_name:,
          description: data.dig(0, 'additionalPlain'),
          url_ats_api:,
          url_ats_main:,
          company_website_url:
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
