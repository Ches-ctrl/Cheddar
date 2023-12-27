# require 'uri'
# require 'net/http'
# require 'json'

class CompanyCreator
  def initialize(url)
    @url = url
  end

  def find_or_create_company
    if @url.include?('greenhouse')
      # TODO: Handle multiple greenhouse URL formats

      match = @url.match(%r{https://boards\.greenhouse\.io/([^/]+)/jobs/\d+})
      if match
        ats_identifier = match[1]
        company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}"

        uri = URI(company_api_url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)

        # Extract the company name
        company_name = data['name']
        description = data['content']

        p company_name

        # TODO: Get properly capitalised company name from API
        # TODO: Get company url (when not available from API)

        company = Company.find_or_create_by(company_name: company_name)

        company.applicant_tracking_system_id = ApplicantTrackingSystem.find_by(name: 'Greenhouse').id

        p company

        if company.description.nil? || company.description.empty?
          company.update(description: description)
        end
        p company
      else
        puts "Unable to extract company name from URL: #{url}"
      end

      cleaned_url = @url.gsub(/\/jobs\/.*/, '')
      original_url = URI.parse(cleaned_url)
      company.update(url_ats: original_url)

      http = Net::HTTP.new(original_url.host, original_url.port)
      http.use_ssl = true if original_url.scheme == 'https'

      request = Net::HTTP::Get.new(original_url.request_uri)
      response = http.request(request)

      if response.is_a?(Net::HTTPRedirection)
        redirected_url = URI.parse(response['Location'])
        company_website_url = redirected_url.host
        p company_website_url
        company.update(company_website_url: company_website_url)
      else
        company_website_url = original_url.host
        p "No redirect for #{company_website_url}"
      end
    else
      p "Not a Greenhouse job"
    end
    company
  end
end
