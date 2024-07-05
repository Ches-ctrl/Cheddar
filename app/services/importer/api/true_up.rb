module Importer
  module Api
    class TrueUp < JobPostingsApi
      ALGOLIA_APPLICATION_ID = '4045RIZNH3'
      ALGOLIA_AGENT = 'Algolia for JavaScript (4.20.0); Browser (lite); instantsearch.js (4.58.0); react (18.2.0); react-instantsearch (7.2.0); react-instantsearch-core (7.2.0); next.js (13.1.1); JS Helper (3.14.2)'
      ALGOLIA_API_KEY = '1e21d9e9b2347abcdd2a64d409a74659'

      def initialize
        @ats = fetch_ats
        super(@ats, api_details, Url::CreateTrueupJobFromUrlJob)
      end

      private

      def api_details
        {
          endpoint:,
          verb: :post,
          options: {
            params:,
            headers:,
            body:
          }
        }
      end

      def body
        hits_per_page = 2000
        max_values_per_facet = 2000
        {
          requests: [
            {
              indexName: 'job',
              params: "facetFilters=[[\"job_locations_combined:🇬🇧 London, UK\",\"job_locations_combined:🇬🇧 United Kingdom (remote)\"],[\"job_categories_lvl0:Engineering (Software)\"]]&facets=[\"job_categories_lvl0\",\"job_locations_combined\"]&hitsPerPage=#{hits_per_page}&maxValuesPerFacet=#{max_values_per_facet}&query=&tagFilters="
            }
          ]
        }.to_json
      end

      def endpoint
        @ats.url_all_jobs.sub('XXX', ALGOLIA_APPLICATION_ID.downcase)
      end

      def fetch_ats
        ApplicantTrackingSystem.find_by(name: 'TrueUp')
      end

      def headers
        {
          'Content-Type': 'application/json'
        }
      end

      def params
        {
          'x-algolia-agent': ALGOLIA_AGENT,
          'x-algolia-api-key': ALGOLIA_API_KEY,
          'x-algolia-application-id': ALGOLIA_APPLICATION_ID
        }
      end

      def redirect?(_json_data)
        true
      end
    end
  end
end
