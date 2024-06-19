module Categorizer
  class CompanyDetailsFromUrl
    include CheckUrlIsValid

    def initialize(url)
      @url = url
    end

    def call
      api_url = "https://api.crunchbase.com/api/v4/searches/organizations?user_key=#{ENV.fetch('CRUNCHBASE_API_KEY')}"
      request_body = {
        field_ids: [
          'name',
          'short_description',
          'linkedin',
          'website_url',
          'rank_org'
        ],
        order: [
          {
            field_id: 'rank_org',
            sort: 'asc'
          }
        ],
        query: [
          {
            type: 'predicate',
            field_id: 'website_url',
            operator_id: 'domain_eq',
            values: [
              @url
            ]
          }
        ],
        limit: 1
      }
      result = json_post_request(api_url, request_body)
      company_details = result&.dig('entities', 0, 'properties')
      return unless company_details

      {
        name: company_details['name'],
        description: company_details['short_description'],
        url_linkedin: company_details.dig('linkedin', 'value')&.sub('http://', 'https://'),
        url_website: company_details['website_url']&.sub('http://', 'https://')
      }
    end
  end
end
