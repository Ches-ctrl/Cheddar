module Ats
  module Recruitee
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        name, description, url_website, url_linkedin = scrape_company_page(url_ats_main)
        data = fetch_company_api_data(url_ats_api)
        {
          name: data.dig(0, 'company_name') || name, # company not created unless name available from api or website
          description:,
          url_website:,
          url_linkedin:,
          url_ats_api:,
          url_ats_main:,
          total_live: data.count
        }
      end

      def fetch_company_api_data(url_ats_api)
        data = get_json_data(url_ats_api)
        data&.dig('offers') || {}
      end

      def scrape_company_page(url)
        puts "attempting to scrape #{url}"
        html = get(url)
        return unless html

        doc = Nokogiri::HTML.parse(html)

        [
          scrape_name(doc),
          scrape_description(doc),
          scrape_website(doc),
          scrape_linkedin(doc)
        ]
      end

      def scrape_name(doc)
        meta_tag = doc.at_xpath('//meta[@property="og:site_name"]')
        # return meta_tag['content'] if meta_tag && meta_tag['content']
        return meta_tag['content'] if meta_tag && meta_tag['content']

        logo_text = doc.at_xpath('//img[contains(@class, "custom-css-style-navigation-logo-image")]/@alt')&.value
        return logo_text.sub(' logo', '') if logo_text
      end

      def scrape_description(doc)
        description_elements = doc.xpath('//p[contains(@class, "sc-1npqnwg-9")]')
        description_elements
          .uniq
          .select { |e| e.inner_text.match?(/\./) && e.inner_text.size > 20 }
          .map { |e| "<p>#{e.inner_text}</p>" }
          .join('<br>')
      end

      def scrape_website(doc)
        website_link = doc.at_xpath('//a[@data-cy="navigation-section-link-item" and starts-with(@href, "https://")]')
        return website_link['href'] if website_link

        website_link = doc.at_xpath('//a[@data-cy="navigation-section-button" and starts-with(@href, "https://")]')
        return website_link['href'] if website_link

        dropdown_link = doc.at_xpath('//a[@role="menuitem" and starts-with(@href, "https://")]')
        return dropdown_link['href'] if dropdown_link
      end

      def scrape_linkedin(doc)
        linkedin_link = doc.at_xpath('//a[@title="linkedin" or @aria-label="linkedin"]')
        return linkedin_link['href'] if linkedin_link
      end
    end
  end
end
