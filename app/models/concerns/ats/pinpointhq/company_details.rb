module Ats
  module Pinpointhq
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        name, url_website, url_linkedin = scrape_company_page(url_ats_main)
        {
          name:,
          url_ats_api:,
          url_ats_main:,
          url_website:,
          url_linkedin:,
          total_live: fetch_total_live(ats_identifier)
        }
      end

      private

      def scrape_company_page(url_ats_main)
        begin
          html = URI.parse(url_ats_main).open
        rescue OpenURI::HTTPError
          puts "Couldn't load url: #{url_ats_main}"
          return []
        end
        doc = Nokogiri::HTML.parse(html)
        name = doc.at_xpath("//div[contains(@class, 'hide-sm-block')][1]//img/@alt")
        name = name&.text&.sub(' - Home', '')
        links = doc.xpath("//div[@class='external-footer__content']//a/@href").map(&:value)
        website_link = links.first
        linkedin_link = links.find { |link| link.include?('linkedin.com') }
        url_website = website_link
        url_linkedin = linkedin_link
        [name, url_website, url_linkedin]
      end
    end
  end
end
