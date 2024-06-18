module Url
  class EnrichCompanyFromUrl
    include CheckUrlIsValid

    def initialize(url)
      @url = url
      @domain = URI.parse(url).host.split('.').last(2).join('.')
    end

    def call
      endpoint = "https://companyenrichment.abstractapi.com/v2?api_key=#{ENV.fetch('ABSTRACT_API_KEY')}&domain=#{@domain}"
      data = get_json_data(endpoint)
      return unless data

      {
        name: data['company_name'],
        description: data['description'],
        industry: data['industry'],
        url_linkedin: data['linkedin_url']
      }
    end
  end
end
