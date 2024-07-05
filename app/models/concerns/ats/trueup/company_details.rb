module Ats
  module Trueup
    module CompanyDetails
      def company_details_from_data(data)
        p "Fetching company details from data"
        {
          name: data['company'],
          url_website: data['company_url_clean'],
          description: Flipper.enabled?(:company_description) ? data['business_description_short'] : 'Not added yet'
        }
      end
    end
  end
end
