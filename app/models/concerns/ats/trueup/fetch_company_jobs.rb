module Ats
  module Trueup
    module FetchCompanyJobs
      def fetch_company_jobs(_ats_identifier)
        algolia_agent = 'Algolia for JavaScript (4.20.0); Browser (lite); instantsearch.js (4.58.0); react (18.2.0); react-instantsearch (7.2.0); react-instantsearch-core (7.2.0); next.js (13.1.1); JS Helper (3.14.2)'
        algolia_api_key = '1e21d9e9b2347abcdd2a64d409a74659'
        algolia_application_id = '4045RIZNH3'
        algolia_base = url_all_jobs.sub('XXX', algolia_application_id.downcase)
        query_string = "?x-algolia-agent=#{algolia_agent}&x-algolia-api-key=#{algolia_api_key}&x-algolia-application-id=#{algolia_application_id}"
        endpoint = "#{algolia_base}#{query_string}"

        json_post_request(endpoint, request_body)
      end

      private

      def request_body
        # TODO: can I just make one request with hits_per_page set to 10,000?
        hits_per_page = 2000
        max_values_per_facet = 2000
        {
          requests: [
            {
              indexName: 'job',
              params: "facetFilters=[[\"job_locations_combined:🇬🇧 London, UK\",\"job_locations_combined:🇬🇧 United Kingdom (remote)\"],[\"job_categories_lvl0:Engineering (Software)\"]]&facets=[\"job_categories_lvl0\",\"job_locations_combined\"]&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&query=&tagFilters="
            },
            {
              indexName: 'job',
              params: "analytics=false&clickAnalytics=false&facetFilters=[[\"job_locations_combined:🇬🇧 London, UK\",\"job_locations_combined:🇬🇧 United Kingdom (remote)\"]]&facets=[\"job_categories_lvl0\"]&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&page=0&query="
            },
            {
              indexName: 'job',
              params: "analytics=false&clickAnalytics=false&facetFilters=[[\"job_categories_lvl0:Engineering (Software)\"]]&facets=job_locations_combined&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&page=0&query="
            },
            {
              indexName: 'job',
              params: "facetFilters=[[\"job_locations_combined:🇬🇧 London, UK\",\"job_locations_combined:🇬🇧 United Kingdom (remote)\"],[\"job_categories_lvl0:Engineering (Software)\"]]&facets=[\"job_categories_lvl0\",\"job_locations_combined\"]&highlightPostTag=__/ais-highlight__&highlightPreTag=__ais-highlight__&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&page=0&query=&tagFilters="
            },
            {
              indexName: 'job',
              params: "analytics=false&clickAnalytics=false&facetFilters=[[\"job_locations_combined:🇬🇧 London, UK\",\"job_locations_combined:🇬🇧 United Kingdom (remote)\"]]&facets=[\"job_categories_lvl0\"]&highlightPostTag=__/ais-highlight__&highlightPreTag=__ais-highlight__&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&page=0&query="
            },
            {
              indexName: 'job',
              params: "analytics=false&clickAnalytics=false&facetFilters=[[\"job_categories_lvl0:Engineering (Software)\"]]&facets=job_locations_combined&highlightPostTag=__/ais-highlight__&highlightPreTag=__ais-highlight__&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&page=0&query="
            }
          ]
        }
      end
    end
  end
end
