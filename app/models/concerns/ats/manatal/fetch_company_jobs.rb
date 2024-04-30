module Ats
  module Manatal
    module FetchCompanyJobs
      def fetch_company_jobs(ats_identifier)
        endpoint = "#{url_api}#{ats_identifier}/jobs/"
        all_jobs_data = []
        page = 1
        loop do
          url = "#{endpoint}?page=#{page}"
          p "Fetching job data - #{url}"
          return unless (page_data = get_json_data(url))

          all_jobs_data += page_data['results']
          return all_jobs_data unless page_data['next']

          page += 1
        end
      end
    end
  end
end
