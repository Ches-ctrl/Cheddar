module Ats
  module Workday
    module CompanyDetails
      private

      # get name from job
      # get description from sidebar_data
      # get website from approot/sidebar
      # website -> Crunchbase -> more reliable name and description

      def company_details(ats_identifier)
        api_base, url_ats_main, tenant = parse_identifier(ats_identifier)
        sidebar_api_url, approot_api_url, url_ats_api = build_endpoints(api_base)

        sidebar_data = get_json_data(sidebar_api_url)
        approot_data = get_json_data(approot_api_url)
        return {} unless sidebar_data || approot_data

        url_website = approot_data&.dig('header', 'homePageURL')
        name, website = fetch_name_and_website(ats_identifier)
        url_website = website unless url_website.present?

        {
          name: name || tenant.capitalize,
          description: Flipper.enabled?(:company_description) ? fetch_company_description(sidebar_data) : 'Not added yet',
          url_ats_api:,
          url_ats_main:,
          url_careers: check_for_careers_url_redirect(url_ats_main),
          url_website:,
          url_linkedin: fetch_linkedin(approot_data),
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

      def build_endpoints(api_base)
        sidebar_api_url = "#{api_base}sidebar"
        approot_api_url = "#{api_base}approot"
        url_ats_api = "#{api_base}jobs"
        [sidebar_api_url, approot_api_url, url_ats_api]
      end

      def fetch_name_and_website(ats_identifier)
        job_data = fetch_one_job(ats_identifier)
        return unless job_data

        fetch_company_name_and_website_from_job(ats_identifier, job_data)
      end

      def fetch_company_name_and_website_from_job(ats_identifier, job_data)
        job_id = fetch_id(job_data)
        endpoint = job_url_api(url_api, ats_identifier, job_id)
        data = get_json_data(endpoint)
        return unless data

        name = data.dig('hiringOrganization', 'name')
        website = data.dig('hiringOrganization', 'url')
        [name, website]
      end

      def fetch_company_description(sidebar_data)
        return unless sidebar_data

        sidebar_data.find do |data|
          type = data['type']&.downcase
          break data['text'] if %w[text image].include?(type)
        end
      end

      def fetch_linkedin(approot_data)
        return unless approot_data

        socials = approot_data.dig('footer', 'socialLinksList')
        linkedin = socials&.find { |e| e['label'] == 'LinkedIn' }
        linkedin&.dig('uri')
      end
    end
  end
end
