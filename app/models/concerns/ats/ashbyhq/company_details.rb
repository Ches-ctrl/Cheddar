module Ats
  module Ashbyhq
    module CompanyDetails
      private

      def company_details(ats_identifier)
        company_name = ats_identifier.humanize
        {
          company_name:,
          url_ats_api: "#{base_url_api}#{ats_identifier}?includeCompensation=true",
          url_ats_main: "#{base_url_main}#{ats_identifier}"
        }
      end
    end
  end
end
