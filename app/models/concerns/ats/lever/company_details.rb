module Ats
  module Lever
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api = "#{base_url_api}#{ats_identifier}/?mode=json"
        url_ats_main = "#{base_url_main}#{ats_identifier}"
        company_name, company_website_url = scrape_company_page(ats_identifier, url_ats_main)
        data = get_json_data(url_ats_api)
        {
          company_name:,
          description: data.dig(0, 'additionalPlain'),
          url_ats_api:,
          url_ats_main:,
          company_website_url:
        }
      end

      def scrape_company_page(ats_identifier, url_ats_main)
        puts "attempting to scrape #{url_ats_main}"
        html = get(url_ats_main)
        return unless html

        doc = Nokogiri::HTML.parse(html)
        title = doc.at_xpath('//head/title')&.text
        return if title.include?('Not found')

        element = doc.at_xpath('//div[contains(@class, "main-footer-text page-centered")]//a')
        if element.text.include?(' Home Page')
          [element.text.sub(' Home Page', ''), element['href']]
        elsif title.downcase.gsub(/[^a-z]/, '').include?(ats_identifier.downcase.gsub(/[^a-z]/, '')) ||
              ats_identifier.downcase.gsub(/[^a-z]/, '').include?(title.downcase.gsub(/[^a-z]/, ''))
          [title]
        else
          name = ats_identifier
          name.gsub!(/[^A-Za-z]/, '')
          name.capitalize! if name == name.downcase
          [name]
        end
      end
    end
  end
end
