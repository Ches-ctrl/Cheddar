module Ats
  module Workday
    module CompanyDetails
      private

      def company_details(ats_identifier)
        api_base, url_ats_main, tenant = parse_identifier(ats_identifier)
        sidebar_api_url = "#{api_base}sidebar"
        approot_api_url = "#{api_base}approot"
        url_ats_api = "#{api_base}jobs"

        sidebar_data = get_json_data(sidebar_api_url)
        approot_data = get_json_data(approot_api_url)
        return {} unless sidebar_data || approot_data

        url_careers = check_for_careers_url_redirect(url_ats_main)

        description = sidebar_data.find do |data|
          type = data['type']&.downcase
          break data['text'] if %w[text image].include?(type)
        end

        socials = approot_data.dig('footer', 'socialLinksList')
        linkedin = socials&.find { |e| e['label'] == 'LinkedIn' }
        url_linkedin = linkedin&.dig('uri')
        url_website = approot_data.dig('header', 'homePageURL')

        enriched_data = url_website.present? ? Url::EnrichCompanyFromUrl.new(url_website).call : {}
        name = enriched_data[:name]

        # if EnrichCompany can't find name or website, try the (unreliable) Workday jobs api
        if name.blank? || url_website.blank?
          job_data = fetch_one_job(ats_identifier)
          company_name, website = fetch_company_name_and_website_from_job(ats_identifier, job_data)
          name = company_name unless name.present?
          url_website = website unless url_website.present?
        end

        {
          name: name || tenant.capitalize,
          description: Flipper.enabled?(:company_description) ? description || enriched_data[:description] : 'Not added yet',
          url_ats_api:,
          url_ats_main:,
          url_careers:,
          url_website:,
          url_linkedin: url_linkedin || enriched_data[:url_linkedin],
          industry: enriched_data[:industry],
          total_live: fetch_total_live(ats_identifier)
          # can get logo_url from sidebar_data
        }
      end

      def check_for_careers_url_redirect(url_ats_main)
        url_ats_main
      end

      def fetch_base_url(ats_identifier)
        parse_identifier(ats_identifier).first
      end

      def parse_identifier(ats_identifier)
        tenant, site_id, version = ats_identifier.split('/')
        version ||= 1
        base_url = url_api.gsub('XXX', tenant).sub('YYY', site_id).sub('ZZZ', version)
        url_ats_main = url_base.sub('XXX', tenant).sub('YYY', site_id).sub('ZZZ', version)
        [base_url, url_ats_main, tenant]
      end

      def fetch_company_name_and_website_from_job(ats_identifier, job_data)
        job_id = fetch_id(job_data)
        endpoint = job_url_api(url_api, ats_identifier, job_id)
        puts "fetching json data from #{endpoint}..."
        data = get_json_data(endpoint)
        name = data.dig('hiringOrganization', 'name')
        website = data.dig('hiringOrganization', 'url')
        puts "Company name is #{name}."
        puts "Website is #{website}."
        [name, website]
      end
    end
  end
end
