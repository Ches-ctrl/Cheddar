module Ats
  module Workday
    module FetchCompanyJobs
      def fetch_one_job(ats_identifier)
        fetch_company_jobs(ats_identifier, fetch_one_job_only: true)
      end

      def fetch_company_jobs(ats_identifier, fetch_one_job_only: false)
        api_base = fetch_base_url(ats_identifier)
        limit = 20
        initial_parameters = { endpoint: "#{api_base}jobs", limit: }
        subsidiary_id = ats_identifier.split('/').last if ats_identifier.count('/') > 2

        data = fetch_chunk(initial_parameters) # get facets array to build full_parameters
        full_parameters = {
          subsidiary_id:,
          country_parameter: find_facet_parameter_in_facets(data['facets'], 'country'),
          company_parameter: (find_facet_parameter_in_facets(data['facets'], 'company') if subsidiary_id)
        }.merge(initial_parameters)

        puts 'fetching page 1 of jobs...'
        data = fetch_chunk(full_parameters) # fetch first tranche of jobs
        total_live = data['total']
        return unless total_live&.positive?

        jobs = data['jobPostings']
        return [jobs.first, total_live] if fetch_one_job_only

        page = 1
        while page * limit < total_live
          puts "fetching page #{page + 1} of jobs..." if page.positive?
          data = fetch_chunk(full_parameters, page) # fetch additional tranches
          jobs += data['jobPostings']
          page += 1
        end
        jobs
      end

      private

      def fetch_chunk(params, page = 0)
        puts "fetching jobs from #{params[:endpoint]}, page##{page + 1}..."
        limit = params[:limit] || 20
        request_body = {
          limit:,
          offset: page * limit,
          appliedFacets: {},
          searchText: ""
        }
        if params[:country_parameter]
          country_facet = { params[:country_parameter].to_sym => ['29247e57dbaf46fb855b224e03170bc7'] } # returns UK jobs only
          request_body[:appliedFacets].merge!(country_facet)
        end
        if params[:company_parameter]
          company_facet = { params[:company_parameter].to_sym => [params[:subsidiary_id]] }
          request_body[:appliedFacets].merge!(company_facet)
        end
        json_post_request(params[:endpoint], request_body)
      end

      def find_facet_parameter_in_facets(facets, parameter)
        queue = [facets]

        until queue.empty?
          current_level = queue.shift

          current_level.each do |facet|
            break unless facet['values']
            return facet['facetParameter'] if facet.is_a?(Hash) && (facet['descriptor']&.downcase&.include?(parameter) || facet['facetParameter']&.downcase&.include?(parameter))

            queue << facet['values'] if facet.is_a?(Hash) && facet['values']
          end
        end

        nil
      end
    end
  end
end
