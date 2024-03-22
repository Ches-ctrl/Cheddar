module Ats
  module Manatal
    module CompanyDetails
      extend ActiveSupport::Concern

      def self.find_or_create(_ats_identifier)
        # TODO: add method here
        return
      end

      def self.get_company_details(url, ats_system, ats_identifier)
        p "Getting Manatal company details - #{url}"

        # TODO: Handle logos

        data = fetch_company_data(ats_system, ats_identifier)

        p data

        company_name = data['name']
        company = Company.find_by(company_name:)

        if company
          p "Existing company - #{company.company_name}"
        else
          company = Company.create(
            company_name:,
            ats_identifier:,
            applicant_tracking_system_id: ats_system.id,
            url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}",
            url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}",
            description: data['description'],
            company_website_url: data['website']
            # facebook: data['facebook_url'],
            # linkedin: data['linkedin_url'],
          )

          company.total_live = fetch_total_live(ats_system, ats_identifier)
          p "Total live - #{company.total_live}"

          p "Created company - #{company.company_name}" if company.persisted?
        end
        company
      end

      def self.fetch_company_data(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}/"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def self.fetch_total_live(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}/jobs/"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['count']
      end
    end
  end
end
