module Ats
  module Greenhouse
    module FetchCompanyJobs
      extend ActiveSupport::Concern
      include Constants

      def self.call(ats_identifier)
        company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs"
        uri = URI(company_api_url)
        begin
          response = Net::HTTP.get(uri)
        rescue Errno::ECONNRESET => e
          puts "Connection reset by peer: #{e}"
          return
        end
        data = JSON.parse(response)
        return data['jobs']
      end

      def return_relevant_jobs
        data = fetch_company_jobs
        relevant_jobs = []
        data['jobs']&.each do |job|
          relevant_jobs << job['absolute_url'] if JOB_TITLE_KEYWORDS.any? { |keyword| job['title'].downcase.match?(keyword) }
        end
        relevant_jobs
      end

      def fetch_company_jobs
        company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{@ats_identifier}/jobs"
        uri = URI(company_api_url)
        begin
          response = Net::HTTP.get(uri)
        rescue Errno::ECONNRESET => e
          puts "Connection reset by peer: #{e}"
          return
        end
        data = JSON.parse(response)
        return data
      end
    end
  end
end
