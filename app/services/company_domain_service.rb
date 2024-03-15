require 'net/http'
require 'uri'
require 'json'

class CompanyDomainService
  def self.lookup_domain(company_name)
    uri = URI("https://autocomplete.clearbit.com/v1/companies/suggest?query=#{URI.encode_www_form_component(company_name)}")
    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/json'

    response= Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      results = JSON.parse(response.body)
      match = results.find { |company| company['name'].downcase == company_name.downcase }
      if match
        match
      else
        nil
      end
    else
      nil
    end
  rescue => e
    Rails.logger.error("Error fetching company info from Marcom Robot: #{e.message}")
  end
end
