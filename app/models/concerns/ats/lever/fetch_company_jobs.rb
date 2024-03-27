module Ats
  module Lever
    module FetchCompanyJobs
      extend AtsMethods
      extend ValidUrl
      include Constants

      def self.call(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}?mode=json"
        return unless (response = get(company_api_url))

        return JSON.parse(response)
      end
    end
  end
end
