class CompanyCreator
  SUPPORTED_ATS_SYSTEMS = [
    'greenhouse',
    'workable',
    'lever',
    'smartrecruiters',
    'ashby',
    'totaljobs',
    'simplyhired',
    'workday',
    'tal.net',
    # 'indeed',
    # 'freshteam',
    # 'phenom',
    # 'jobvite',
    # 'icims',
  ].freeze

  def initialize(url)
    @url = url
  end

  # def create_company
  #   ats_system = SUPPORTED_ATS_SYSTEMS.find { |ats| @url.include?(ats) }

  #   if ats_system
  #     ats_module = get_ats_module(ats_system)
  #     ats_module.get_company_details(@url)
  #   else
  #     p "Unable to detect ATS system for URL: #{@url}"
  #     return nil
  #   end
  # end

  def find_or_create_company
    ats_system = SUPPORTED_ATS_SYSTEMS.find { |ats| @url.include?(ats) }

    if ats_system
      ats_module = get_ats_module(ats_system)
      ats_module.get_company_details(@url)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end

    match = parse_greenhouse_url
    return unless match
    ats_identifier = match[1]

    company_name, description = fetch_company_data(ats_identifier)

    company = Company.find_by(company_name: company_name)
    new_company = false

    if company.nil?
      company = Company.create(company_name: company_name)
      new_company = true
    end

    p new_company

    # Old method, splitting out create to call GetAllJobUrls function
    # company = Company.find_or_create_by(company_name: company_name)

    update_description_and_ats(company, description, ats_identifier)
    update_company_url_and_website(company) if company.url_ats.blank?

    # p "Calling GetAllJobUrls"
    # GetAllJobUrls.new(company).get_all_job_urls if new_company
    # p "Finished GetAllJobUrls"

    puts "Created / Updated company - #{company.company_name}"
    company
  end

  private

  def parse_greenhouse_url
    @url.match(%r{https://boards\.greenhouse\.io/([^/]+)/jobs/\d+})
  end

  def fetch_company_data(ats_identifier)
    company_api_url = "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}"
    uri = URI(company_api_url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    [data['name'], data['content']]
  end

  def update_description_and_ats(company, description, ats_identifier)
    company.update(description: description) if company.description.blank?
    company.update(applicant_tracking_system_id: ApplicantTrackingSystem.find_by(name: 'Greenhouse').id) if company.applicant_tracking_system_id.blank?
    company.update(ats_identifier: ats_identifier) if company.ats_identifier.blank?
  end

  def update_company_url_and_website(company)
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
      company.update(url_careers: redirected_url)
      company.update(company_website_url: company_website_url)
    else
      p "No redirect for #{company_website_url}"
    end
  end

  def get_ats_module(ats_system)
    module_name = "Ats::#{ats_system.capitalize}"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end
end
