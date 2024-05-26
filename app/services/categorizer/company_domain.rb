require 'net/http'
require 'uri'
require 'json'

module Categorizer
  class CompanyDomain
    def self.lookup_domain(name)
      uri = URI("https://autocomplete.clearbit.com/v1/companies/suggest?query=#{URI.encode_www_form_component(name)}")
      request = Net::HTTP::Get.new(uri)
      request['Accept'] = 'application/json'

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      return unless response.is_a?(Net::HTTPSuccess)

      results = JSON.parse(response.body)
      results.find { |company| company['name'].downcase == name.downcase }
    rescue => e
      puts "Error fetching company info from Clearbit: #{e.message}"
    end
  end
end
