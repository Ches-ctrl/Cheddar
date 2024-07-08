module Ats
  module Trueup
    module CompanyDetails
      def fetch_company_id(data)
        p "Fetching company ID"
        data['company_id']
      end

      def company_details(ats_identifier)
        data = Importer::Scraper::TrueUpCompanyDetails.call(ats_identifier)
        {
          name: data['company'],
          url_website: data['company_url_clean'], # TODO: make this the long form
          description: Flipper.enabled?(:company_description) ? data['business_description_long'] : 'Not added yet',
          industry: data['company_classification'],
          location: data['hq_location']
        }
      end

      def company_details_from_data(_data)
        {}
      end
    end
  end
end
