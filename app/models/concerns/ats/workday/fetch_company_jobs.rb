module Ats
  module Workday
    module FetchCompanyJobs
      include Constants

      def fetch_company_jobs(ats_identifier, fetch_one_job_only: false)
        api_base = fetch_base_url(ats_identifier)
        limit = 20
        initial_parameters = { endpoint: "#{api_base}jobs", limit: }
        subsidiary_id = ats_identifier.split('/').last if ats_identifier.count('/') > 2

        data = fetch_chunk(initial_parameters) # get facets array to build full_parameters
        location_parameters = find_facet_in_facets(data['facets'], [/location/i, /countr(y|ies)/i], JOB_LOCATION_KEYWORDS.excluding(/remote/))
        company_parameters = find_facet_in_facets(data['facets'], [/compan(y|ies)/i], [subsidiary_id], 'id') if subsidiary_id
        full_parameters = {
          location_parameters:,
          company_parameters:
        }.merge(initial_parameters)

        data = fetch_chunk(full_parameters) # fetch first tranche of jobs
        return data if fetch_one_job_only

        total_live = data['total']
        return unless total_live&.positive?

        puts "Couldn't find a location parameter. Returning all jobs regardless of location." unless location_parameters.present?
        jobs = data['jobPostings']

        page = 1
        while page * limit < total_live
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
        request_body[:appliedFacets].merge!(params[:location_parameters]) if params[:location_parameters]
        request_body[:appliedFacets].merge!(params[:company_parameters]) if params[:company_parameters]
        p request_body
        json_post_request(params[:endpoint], request_body)
      end

      def find_facet_in_facets(facets, parameter_array, descriptor_array, descriptor_field = 'descriptor')
        queue = [[facets, nil]]
        parameters = Hash.new { |hash, key| hash[key] = [] }

        until queue.empty? || parameters.present?
          current_level, facet_parameter = queue.shift

          current_level.each do |facet|
            if facet.is_a?(Hash) && facet['values']
              queue << [facet['values'], facet['facetParameter'].to_sym] if parameter_array.any? { |parameter| facet['facetParameter']&.match?(parameter) } || parameter_array.any? { |parameter| facet['descriptor']&.match?(parameter) }
            elsif facet[descriptor_field] && descriptor_array.any? { |descriptor| facet[descriptor_field].match?(descriptor) }
              parameters[facet_parameter] << facet['id']
            end
          end
        end

        parameters
      end
    end
  end
end
