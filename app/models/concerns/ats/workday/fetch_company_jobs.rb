module Ats
  module Workday
    module FetchCompanyJobs
      def fetch_total_live(ats_identifier)
        fetch_company_jobs(ats_identifier, fetch_quantity_only: true)
      end

      def fetch_one_job(ats_identifier)
        fetch_company_jobs(ats_identifier, fetch_one_job_only: true)
      end

      def fetch_company_jobs(ats_identifier, fetch_quantity_only: false, fetch_one_job_only: false)
        @jobs = []
        api_base = fetch_base_url(ats_identifier)
        endpoint = "#{api_base}jobs"
        limit = 20
        data = fetch_chunk(endpoint, limit)
        total_live = data['total']
        return unless total_live&.positive?
        return total_live if fetch_quantity_only
        return @jobs.first if fetch_one_job_only

        page = 1
        while page * limit < total_live
          fetch_chunk(endpoint, limit, page)
          page += 1
        end
        @jobs
      end

      private

      def fetch_chunk(endpoint, limit, page = 0)
        puts "fetching jobs from #{endpoint}, page##{page + 1}..."
        request_body = {
          limit:,
          offset: page * limit
        }
        data = json_post_request(endpoint, request_body)
        @jobs += data['jobPostings']
        data
      end
    end
  end
end
