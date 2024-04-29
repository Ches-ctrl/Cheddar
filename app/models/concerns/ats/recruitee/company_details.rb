module Ats
  module Recruitee
    module CompanyDetails
      def company_details(ats_identifier)
        url_ats_api, url_ats_main = replace_ats_identifier(ats_identifier)
        name = ats_identifier.capitalize
        {
          name:,
          url_ats_api:,
          url_ats_main:
        }
      end
    end
  end
end
