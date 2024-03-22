module Ats
  module Greenhouse
    module CompanyDetails
      extend ActiveSupport::Concern
      extend AtsMethods
      extend ValidUrl

      # TODO: abstract nearly all of this logic into a concern shared by all ATS modules
      # TODO: rename this to something like self.find_or_create_company
      def self.find_or_create(ats_identifier)
        company = Company.find_or_create_by(ats_identifier:) do |new_company|
          ats_system = this_ats
          company_name, description = fetch_company_data(ats_system, ats_identifier)
          new_company.company_name = company_name
          new_company.description = description
          new_company.applicant_tracking_system = ats_system
          new_company.url_ats_api = "#{ats_system.base_url_api}#{ats_identifier}"
          new_company.url_ats_main = "#{ats_system.base_url_main}#{ats_identifier}"
          check_for_careers_url_redirect(new_company)
          puts "Created company - #{new_company.company_name}"
        end

        return company
      end

      # def self.get_company_details(ats_system, ats_identifier)
      #   p "Getting greenhouse company details - #{ats_identifier}"

      #   company_name, description = fetch_company_data(ats_system, ats_identifier)
      #   return unless company_name

      #   company = Company.find_or_create_by!(company_name:) do |company|
      #     puts "Created company - #{company.company_name}"
      #     company.description = description
      #     company.ats_identifier = ats_identifier
      #     company.applicant_tracking_system_id = ats_system.id
      #     company.url_ats_api = "#{ats_system.base_url_api}#{ats_identifier}"
      #     company.url_ats_main = "#{ats_system.base_url_main}#{ats_identifier}"
      #     company.applicant_tracking_system = ats_system
      #     check_for_careers_url_redirect(company)
      #   end

      #   return company
      # end

      def self.fetch_company_data(ats_system, ats_identifier)
        company_api_url = "#{ats_system.base_url_api}#{ats_identifier}"
        response = get(company_api_url)
        data = JSON.parse(response)
        [data['name'], data['content']]
      end

      def self.check_for_details(company, ats_system, ats_identifier, description)
        if company.description.nil?
          p "Missing description for #{company.company_name}"
          company.update(description:)
        end

        if company.ats_identifier.nil?
          p "Missing ATS identifier for #{company.company_name}"
          company.update(ats_identifier:)
        end

        if company.applicant_tracking_system_id.nil?
          p "Missing ATS system for #{company.company_name}"
          company.update(applicant_tracking_system_id: ats_system.id)
        end

        if company.url_ats_api.nil?
          p "Missing ATS API URL for #{company.company_name}"
          company.update(url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}")
        end

        return unless company.url_ats_main.nil?

        p "Missing ATS Main URL for #{company.company_name}"
        company.update(url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}")
      end

      def self.check_for_careers_url_redirect(company)
        url = URI(company.url_ats_main)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == 'https'

        request = Net::HTTP::Get.new(url.request_uri)
        response = http.request(request)

        if response.is_a?(Net::HTTPRedirection)
          redirected_url = URI.parse(response['Location'])
          company.update(url_careers: redirected_url)
          company.update(company_website_url: redirected_url.host)
        else
          p "No redirect for #{company.url_ats_main}"
        end
      end
    end
  end
end
