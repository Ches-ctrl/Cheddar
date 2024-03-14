require 'net/http'
require 'uri'
require 'json'

class MacromRobotService
  def self.lookup_domain(company_name)
    uri = URI("https://api.marcomrobot.com/v2/lookup/company/#{URI.encode_www_form_component(company_name)}")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{ENV['MARCOM_ROBOT_API_KEY']}"
    request['Accept'] = 'application/json'

    response= Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      nil
    end
  rescue => e
    Rails.logger.error("Error fetching company info from Marcom Robot: #{e.message}")
  end
end
