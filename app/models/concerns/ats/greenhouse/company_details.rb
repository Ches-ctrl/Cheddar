module Ats::Greenhouse::CompanyDetails
  extend ActiveSupport::Concern

  def self.get_company_details(url)
    p "Getting greenhouse company details - #{url}"
    ats_system = ApplicantTrackingSystem.find_by(name: 'Greenhouse')

    match = parse_url(url)
    return unless match
    ats_identifier = match[1]

    company_name, description = fetch_company_data(ats_identifier)

    company = Company.find_by(company_name: company_name)
    new_company = false

    if company.nil?
      company = Company.create(
        company_name: company_name,
        ats_identifier: ats_identifier,
        applicant_tracking_system_id: ats_system.id,
        url_ats_api: "#{ats_system.base_url_api}#{ats_identifier}",
        url_ats_main: "#{ats_system.base_url_main}#{ats_identifier}"
      )
      new_company = true
      update_description_and_ats(company, description, ats_identifier)
      update_company_url_and_website(company, url)
    end

    # p "Calling GetAllJobUrls"
    # GetAllJobUrls.new(company).get_all_job_urls if new_company
    # p "Finished GetAllJobUrls"

    puts "Created / Updated company - #{company.company_name}"
    company
  end

  def self.parse_url(url)
    # Ability to handle multiple URLs via regex - not tested
    # TODO: Resolve the potential regex match structures and test them (non priority)
    # regex_formats = [
    #   %r{https://boards\.greenhouse\.io/([^/]+)/jobs},
    #   %r{https://boards\.greenhouse\.io/([^/]+)/jobs/\d+},
    #   %r{https://boards\.greenhouse\.io/embed/job_app\?for=([^&]+)},
    #   %r{https://boards\.[^.]+\.greenhouse\.io/embed/job_app\?for=([^&]+)},
    #   %r{https://boards-api\.greenhouse\.io/v1/boards/([^/]+)},
    #   %r{https://boards-api\.greenhouse\.io/v1/boards/([^/]+)/jobs},
    #   %r{https://boards-api\.greenhouse\.io/v1/boards/([^/]+)/jobs/\d+},
    #   %r{https://boards-api\.greenhouse\.io/([^/]+)},
    #   %r{https://boards-api\.greenhouse\.io/([^/]+)/jobs},
    #   %r{https://boards-api\.greenhouse\.io/([^/]+)/jobs/\d+}
    # ]

    # regex_formats.each do |regex|
    #   match = url.match(regex)
    #   if match
    #     company_name = match[1]
    #     puts "Company Name: #{company_name}"
    #     break
    #   end
    # end

    url.match(%r{https://boards\.greenhouse\.io/([^/]+)/jobs/(\d+)})
  end

  def self.fetch_company_data(ats_identifier)
    # Could request the base_url_api from the database but probably more efficient to hardcode here given requirement to split by ATS?
    company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}"
    uri = URI(company_api_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    [data['name'], data['content']]
  end

  def self.update_description_and_ats(company, description, ats_identifier)
    company.update(description: description) if company.description.blank?
    company.update(applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Greenhouse').id) if company.applicant_tracking_system_id.blank?
    company.update(ats_identifier: ats_identifier) if company.ats_identifier.blank?
  end

  def self.update_company_url_and_website(company, url)
    cleaned_url = url.gsub(/\/jobs\/.*/, '')
    original_url = URI.parse(cleaned_url)
    p original_url

    http = Net::HTTP.new(original_url.host, original_url.port)
    http.use_ssl = true if original_url.scheme == 'https'

    request = Net::HTTP::Get.new(original_url.request_uri)
    response = http.request(request)

    if response.is_a?(Net::HTTPRedirection)
      redirected_url = URI.parse(response['Location'])
      company_website_url = redirected_url.host
      company.update(url_careers: redirected_url)
      company.update(company_website_url: company_website_url)
    else
      p "No redirect for #{company_website_url}"
    end
  end
end
