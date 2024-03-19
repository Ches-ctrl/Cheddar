module Ats
  module Greenhouse
    module FetchCompanyJobs
      extend ActiveSupport::Concern

      DEPARTMENT_KEYWORDS = [
        'engineer',
        'software',
        'tech',
        'platform',
        'network',
        'data science',
        'information security',
        'implementation',
        'design system',
        'qa'
      ]

      JOB_TITLE_KEYWORDS = [
        'software',
        'engineer',
        'developer',
        'programmer',
        'ui',
        'ux',
        'qa',
        'data scientist',
        'ml',
        'machine learning',
        'game designer',
        'cybersecurity',
        'it',
        'technical designer',
        'seo'
      ]

      def return_relevant_jobs
        data = fetch_company_jobs(@ats_identifier)
        relevant_jobs = data['jobs'].select do |job|
          search_field = job['title'].downcase.split(/[^a-z0-9]/)
          JOB_TITLE_KEYWORDS.any? { |keyword| search_field.include?(keyword) }
        end
        relevant_jobs.map { |job| job['absolute_url'] }
      end

      def fetch_company_jobs(ats_identifier)
        company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs"
        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        return JSON.parse(response)
      end

      def get_job_urls(data)
        return data['jobs'].map { |job| job['absolute_url'] }
      end

      private

      def fetch_department(job_id)
        job_api_url = "https://boards-api.greenhouse.io/v1/boards/#{@ats_identifier}/jobs/#{job_id}"
        uri = URI(job_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['departments'][0]['name'] unless data['departments'].empty?
      end
    end
  end
end
