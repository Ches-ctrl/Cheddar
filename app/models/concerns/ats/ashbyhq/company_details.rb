module Ats
  module Ashbyhq
    module CompanyDetails
      private

      def company_details(ats_identifier)
        {
          company_name: ats_identifier.humanize,
          url_ats_api: "#{url_api}#{ats_identifier}?includeCompensation=true",
          url_ats_main: "#{url_base}#{ats_identifier}"
        }
      end
    end
  end
end
