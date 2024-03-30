module Ats
  module Lever
    module CompanyDetails
      def find_or_create_company(ats_identifier)
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          company_name, description = fetch_company_data(ats_identifier)
          return unless company_name

          new_company.company_name = company_name
          new_company.description = description
          new_company.applicant_tracking_system = self
          new_company.url_ats_api = "#{base_url_api}#{ats_identifier}/?mode=json"
          new_company.url_ats_main = "#{base_url_main}#{ats_identifier}"
          puts "Created company - #{new_company.company_name}"
        end

        return company
      end

      def fetch_company_data(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}/?mode=json"
        return unless url_valid?(company_api_url)

        response = get(company_api_url)
        data = JSON.parse(response)
        company_name = fetch_company_name(ats_identifier)
        [company_name, data.dig(0, 'additionalPlain')]
      end

      def fetch_company_name(ats_identifier)
        url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
        response = get(url)
        data = JSON.parse(response)
        return data.dig(0, 'name') unless data.blank?
      end
    end
  end
end
