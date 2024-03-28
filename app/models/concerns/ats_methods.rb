module AtsMethods
  def base_url_api
    this_ats.base_url_api
  end

  def this_ats
    match = to_s.match(/Ats::(\w+)(?=\W)/)
    ApplicantTrackingSystem.find_by(name: match[1])
  end

  def try_standard_formats(url, regex_formats)
    regex_formats.each do |regex|
      next unless (match = url.match(regex))

      ats_identifier, job_id = match.captures
      return [ats_identifier, job_id]
    end
    return nil
  end

  def check_for_careers_url_redirect(company)
    url = URI(company.url_ats_main)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'

    request = Net::HTTP::Get.new(url.request_uri)

    max_retries = 2
    retries = 0
    begin
      response = http.request(request)
    rescue Errno::ECONNRESET => e
      retries += 1
      if retries <= max_retries
        sleep(2**retries) # Exponential backoff
        retry
      else
        puts "Check for careers redirect failed after #{max_retries} retries: #{e.message}"
        return false
      end
    end

    if response.is_a?(Net::HTTPRedirection)
      redirected_url = URI.parse(response['Location'])
      company.update(url_careers: redirected_url)
      company.update(company_website_url: redirected_url.host)
    else
      p "No redirect for #{company.url_ats_main}"
    end
  end

  def convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string)
  end

  def convert_from_milliseconds(millisecond_string)
    Time.at(millisecond_string.to_i / 1000)
  end
end
