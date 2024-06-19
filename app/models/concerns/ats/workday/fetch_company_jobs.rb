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
        jobs = []
        api_base = fetch_base_url(ats_identifier)
        endpoint = "#{api_base}jobs"
        limit = 20
        subsidiary_id = ats_identifier.split('/').last if ats_identifier.count('/') > 2
        data = fetch_chunk(endpoint, limit, subsidiary_id)
        total_live = data['total']
        return unless total_live&.positive?
        return total_live if fetch_quantity_only
        return data['jobPostings']&.first if fetch_one_job_only

        page = 1
        while page * limit < total_live
          data = fetch_chunk(endpoint, limit, subsidiary_id, page)
          jobs += data['jobPostings']
          page += 1
        end
        jobs
      end

      private

      def fetch_chunk(endpoint, limit = 20, subsidiary_id = nil, page = 0)
        puts "fetching jobs from #{endpoint}, page##{page + 1}..."
        request_body = {
          limit:,
          offset: page * limit,
          appliedFacets: {
            locationCountry: [
              '29247e57dbaf46fb855b224e03170bc7' # returns UK jobs only
            ]
          },
          searchText: ""
        }
        company_facet = { Company: [ subsidiary_id ] }
        request_body[:appliedFacets].merge!(company_facet) if subsidiary_id
        json_post_request(endpoint, request_body)
      end
    end
  end
end
