module Ats
  module Pinpointhq
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        company_name, company_website_url, url_linkedin = scrape_company_page(url_ats_main)
        {
          company_name:,
          url_ats_api:,
          url_ats_main:,
          company_website_url:,
          url_linkedin:
        }
      end

      def scrape_company_page(url_ats_main)
        html = URI.parse(url_ats_main).open
        doc = Nokogiri::HTML.parse(html)
        name = doc.at_xpath("//div[contains(@class, 'hide-sm-block')][1]//img/@alt")
        company_name = name&.text&.sub(' - Home', '')
        links = doc.xpath("//div[@class='external-footer__content']//a/@href").map(&:value)
        website_link = links.first
        linkedin_link = links.find { |link| link.include?('linkedin.com') }
        company_website_url = website_link
        url_linkedin = linkedin_link
        [company_name, company_website_url, url_linkedin]
      end
    end
  end
end
