module AtsMethods
  def base_url_api
    this_ats.base_url_api
  end

  def this_ats
    match = to_s.match(/Ats::(\w+)(?=\W)/)
    ApplicantTrackingSystem.find_by(name: match[1])
  end

  def check_for_careers_url_redirect(company)
    url = URI(company.url_ats_main)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'

    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)

    if response.is_a?(Net::HTTPRedirection)
      redirected_url = URI.parse(response['Location'])
      company.update(url_careers: redirected_url)
      company.update(company_website_url: redirected_url.host)
    else
      p "No redirect for #{company.url_ats_main}"
    end
  end

  def fetch_additional_fields(job)
    ats = this_ats
    ats.application_fields.get_application_criteria(job)
    update_requirements(job)
    p "job fields getting"
    GetFormFieldsJob.perform_later(job)
    JobStandardizer.new(job).standardize
  end

  def convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string)
  end
end
