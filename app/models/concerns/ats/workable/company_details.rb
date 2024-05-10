module Ats
  module Workable
    module CompanyDetails
      private

      def company_details(ats_identifier)
        # TODO: Add capabilitiy to handle logos, mailbox, etc.
        url_ats_api = "#{url_api}#{ats_identifier}"
        url_ats_main = "#{url_base}#{ats_identifier}"
        data = get_json_data(url_ats_api, use_proxy: true)
        return {} unless data

        url_careers = check_for_careers_url_redirect(url_ats_main)
        {
          name: data['name'],
          description: data.dig('details', 'overview', 'description'),
          url_ats_api:,
          url_ats_main:,
          url_careers:,
          url_website: data['url'],
          total_live: fetch_total_live(ats_identifier)
          # logo_url: "https://workablehr.s3.amazonaws.com/uploads/account/logo/#{data['id']}/logo"
        }
      end

      def check_for_careers_url_redirect(url_ats_main)
      end
    end
  end
end
