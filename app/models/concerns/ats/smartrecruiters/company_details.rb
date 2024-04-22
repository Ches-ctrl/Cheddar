module Ats
  module Smartrecruiters
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api = "#{url_api}#{ats_identifier}/postings"
        data = get_json_data(url_ats_api)
        name, industry = fetch_name_and_industry(data)
        {
          name:,
          description: fetch_description(data),
          industry:,
          url_ats_api:,
          url_ats_main: "#{url_base}#{ats_identifier}",
          total_live: fetch_total_live(ats_identifier)
        }
      end

      def fetch_description(data)
        data['content'].each do |posting|
          next unless ['en', 'en-GB'].include?(posting['language'])

          job_api = posting['ref']
          detailed_data = get_json_data(job_api)
          formatted_description = detailed_data.dig('jobAd', 'sections', 'companyDescription', 'text')
          return sanitize(formatted_description)
        end
        return nil
      end

      def fetch_name_and_industry(data)
        return unless data && data['totalFound'].positive?

        name = data.dig('content', 0, 'company', 'name')
        industry = data.dig('content', 0, 'industry', 'label')
        [name, industry]
      end

      def fetch_total_live(ats_identifier)
        company_api_url = "#{url_api}#{ats_identifier}/postings"
        data = get_json_data(company_api_url)
        data['totalFound']
      end
    end
  end
end
