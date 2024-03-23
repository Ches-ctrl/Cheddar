module Ats
  module Lever
    module CompanyDetails
      extend ActiveSupport::Concern
      extend AtsMethods
      extend ValidUrl

      def self.find_or_create(ats_identifier)
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          ats_system = this_ats
          company_name, description = fetch_company_data(ats_system, ats_identifier)
          return unless company_name

          new_company.company_name = company_name
          new_company.description = description
          new_company.applicant_tracking_system = ats_system
          new_company.url_ats_api = "#{ats_system.base_url_api}#{ats_identifier}/?mode=json"
          new_company.url_ats_main = "#{ats_system.base_url_main}#{ats_identifier}"
          check_for_careers_url_redirect(new_company)
          puts "Created company - #{new_company.company_name}"
        end

        return company
      end

      def self.fetch_company_data(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}/?mode=json"
        return unless valid?(company_api_url)

        response = get(company_api_url)
        data = JSON.parse(response)
        company_name = fetch_company_name(ats_identifier)
        [company_name, data.dig(0, 'additionalPlain')]
      end

      def self.fetch_company_name(ats_identifier)
        url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
        response = get(url)
        data = JSON.parse(response)
        return data.dig(0, 'name') unless data.blank?
      end
    end
  end
end
