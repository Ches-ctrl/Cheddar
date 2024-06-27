module Ats
  module Workday
    module CompanyDetails
      def fetch_subsidiaries(company)
        ats_identifier = company.ats_identifier
        return if ats_identifier.count('/') > 2

        puts "Checking if the company has subsidiaries..."
        data = fetch_company_jobs(ats_identifier, facets_only: true)
        company_facet = data&.find { |f| f['descriptor']&.match?(/compan(y|ies)/i) }
        return unless company_facet

        company_facet['values'].map do |company_data|
          data = {
            name: company_data['descriptor'],
            ats_identifier: "#{company.ats_identifier}/#{company_data['id']}"
          }
          CompanyCreator.call(ats: self, data:)
        end
      end

      # get name from job
      # get description from sidebar_data
      # get website from approot/sidebar
      # website -> Crunchbase -> more reliable name and description

      def company_details(ats_identifier)
        api_base, url_ats_main, tenant = parse_identifier(ats_identifier)
        return {} unless api_base && url_ats_main && tenant

        sidebar_api_url, approot_api_url, url_ats_api = build_endpoints(api_base)

        sidebar_data = get_json_data(sidebar_api_url)
        approot_data = get_json_data(approot_api_url)
        return {} unless sidebar_data || approot_data

        url_website = approot_data&.dig('header', 'homePageURL')
        name, website, total_live = fetch_details_from_jobs_endpoint(ats_identifier)
        url_website = website unless url_website.present?

        {
          name: name || tenant.capitalize,
          description: Flipper.enabled?(:company_description) ? fetch_company_description(sidebar_data) : 'Not added yet',
          url_ats_api:,
          url_ats_main:,
          url_careers: check_for_careers_url_redirect(url_ats_main),
          url_website:,
          url_linkedin: fetch_linkedin(approot_data),
          total_live:
          # can get logo_url from sidebar_data
        }
      end

      def fetch_company_id(data)
        data[:ats_identifier]
      end

      private

      def check_for_careers_url_redirect(url_ats_main)
        url_ats_main
      end

      def fetch_base_url(ats_identifier)
        parse_identifier(ats_identifier).first
      end

      def parse_identifier(ats_identifier)
        tenant, site_id, version = ats_identifier.split('/')
        return unless tenant && site_id

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

      def fetch_details_from_jobs_endpoint(ats_identifier)
        data = fetch_company_jobs(ats_identifier, one_job_only: true)
        job_data = data['jobPostings']&.first
        total_live = data['total']

        name, website = fetch_details_from_job(ats_identifier, job_data)
        [name, website, total_live]
      end

      def fetch_details_from_job(ats_identifier, job_data)
        job_id = fetch_id(job_data)
        data = fetch_detailed_job_data(ats_identifier, job_id)
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
