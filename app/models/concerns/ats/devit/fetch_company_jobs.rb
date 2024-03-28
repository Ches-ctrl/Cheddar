module Ats
  module Devit
    module FetchCompanyJobs
      extend ActiveSupport::Concern
      extend AtsMethods
      extend ValidUrl
      include Constants

      def self.call(ats_identifier)
        company_api_url = "#{base_url_api}#{ats_identifier}/jobs"
        return unless (response = get(company_api_url))

        data = JSON.parse(response)
        return data['jobs']
      end

      def return_relevant_jobs
        data = Ats::Greenhouse::FetchCompanyJobs.call(@ats_identifier)
        relevant_jobs = []
        data&.each do |job|
          relevant_jobs << job['absolute_url'] if JOB_TITLE_KEYWORDS.any? { |keyword| job['title'].downcase.match?(keyword) }
        end
        relevant_jobs
      end
    end
  end
end
