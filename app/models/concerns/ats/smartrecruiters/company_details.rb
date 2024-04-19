module Ats
  module Smartrecruiters
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api = "#{base_url_api}#{ats_identifier}/postings"
        response = get(url_ats_api)
        data = JSON.parse(response)

        company_name, industry = fetch_name_and_industry(data)
        {
          company_name:,
          description: fetch_description(data),
          industry:,
          url_ats_api:,
          url_ats_main: "#{base_url_main}#{ats_identifier}",
          total_live: fetch_total_live(ats_identifier)
        }
      end

      def fetch_description(data)
        data['content'].each do |posting|
          next unless ['en', 'en-GB'].include?(posting['language'])

          job_api = posting['ref']
          response = get(job_api)
          detailed_data = JSON.parse(response)
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
        company_api_url = "#{base_url_api}#{ats_identifier}/postings"
        response = get(company_api_url)
        data = JSON.parse(response)
        data['totalFound']
      end
    end
  end
end
