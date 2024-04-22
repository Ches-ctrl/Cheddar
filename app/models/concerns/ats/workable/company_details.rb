module Ats
  module Workable
    module CompanyDetails
      private

      def company_details(ats_identifier)
        # TODO: Add capabilitiy to handle logos, mailbox, etc.
        url_ats_api = "#{url_api}#{ats_identifier}"
        url_ats_main = "#{url_base}#{ats_identifier}"
        data = get_json_data(url_ats_api)
        url_careers = check_for_careers_url_redirect(url_ats_main)
        {
          name: data['name'],
          description: data.dig('details', 'overview', 'description'),
          url_ats_api:,
          url_ats_main:,
          url_careers:,
          url_website: data['url']
          # logo_url: "https://workablehr.s3.amazonaws.com/uploads/account/logo/#{data['id']}/logo"
        }
      end

      def check_for_careers_url_redirect(url_ats_main)
      end

      # TODO: If there's a scenario where check_for_details is necessary, call it from ApplicantTrackingSystem

      # def check_for_details(company, ats_system, ats_identifier, description)
      #   if company.description.nil?
      #     p "Missing description for #{company.name}"
      #     company.update(description:)
      #   end

      #   if company.ats_identifier.nil?
      #     p "Missing ATS identifier for #{company.name}"
      #     company.update(ats_identifier:)
      #   end

      #   if company.applicant_tracking_system_id.nil?
      #     p "Missing ATS system for #{company.name}"
      #     company.update(applicant_tracking_system_id: ats_system.id)
      #   end

      #   if company.url_ats_api.nil?
      #     p "Missing ATS API URL for #{company.name}"
      #     company.update(url_ats_api: "#{ats_system.url_api}#{ats_identifier}")
      #   end

      #   return unless company.url_ats_main.nil?

      #   p "Missing ATS Main URL for #{company.name}"
      #   company.update(url_ats_main: "#{ats_system.url_base}#{ats_identifier}")
      # end
    end
  end
end
