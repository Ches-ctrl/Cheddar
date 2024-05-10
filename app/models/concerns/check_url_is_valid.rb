module CheckUrlIsValid
  extend ActiveSupport::Concern

  # TODO: This doesn't yet work sufficiently well - often you'll have a successfull or redirect HTTP call but an error message on the page so will need parsing by Nokogiri with a regex for the error message
  # Workable: query params - ?not_found=true redirect to main page
  # Lever: Sorry, we couldn't find anything here. The job posting you're looking for might have closed, or it has been removed. (404 error).
  # Bamboo: Thank you for your interest. Unfortunately, we are not hiring at this time. Please check back as we will most certainly be looking for great people to join our team in the future.

  def job_is_live?(url, ats)
    response = get_response(url)
    if response.is_a?(Net::HTTPRedirection || Net::HTTPMovedPermanently)
      redirect = fetch_redirect(url, response)
      puts "checking the redirect url: #{redirect}"
      ats_identifier, job_id = ats.parse_url(redirect)
      return ats_identifier.present? && job_id.present?
    end
    response.is_a?(Net::HTTPSuccess)
  end

  def fetch_redirect(url, response)
    uri = URI.parse(url)
    domain = uri.host
    path = response['location']
    "#{domain}/#{path}"
  end

  def get_response(url, max_retries = 1)
    uri = URI(url)
    retries = 0
    begin
      response = Net::HTTP.get_response(uri)
    rescue Net::OpenTimeout, Net::ReadTimeout, EOFError, Errno::ECONNRESET, Errno::ECONNREFUSED, OpenSSL::SSL::SSLError => e
      retries += 1
      if retries <= max_retries
        sleep(2**retries) # Exponential backoff
        retry
      else
        puts "Failed after #{max_retries} retries: #{e.message}"
        return false
      end
    end
    return response
  end

  def get(url, max_retries = 1)
    uri = URI(url)
    retries = 0
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError, Net::OpenTimeout => e
      retries += 1
      if retries <= max_retries
        sleep 2 ** retries # Exponential backoff
        retry
      else
        puts "Failed after #{retries} retries: #{error.message}"
        return nil
      end
    rescue Net::HTTPError => e
      puts "Failed to load #{url}: #{e.message}" # Don't retry
      return nil
    end

    return response
  end

  def get_with_proxy(url)
    proxy_url = "http://api.scrapeup.com/?api_key=#{ENV.fetch('SCRAPEUP_API_KEY')}&url=#{url}"
    puts "REQUEST DENIED, REROUTING THROUGH PROXY: #{proxy_url}"
    get(proxy_url)
  end

  def get_json_data(api_url, use_proxy: false)
    retries_left = 1
    response = get(api_url)
    return {} if response == "Not Found" # Workable 404 response

    begin
      JSON.parse(response)
    rescue JSON::ParserError => e
      if use_proxy && retries_left.positive?
        retries_left -= 1
        response = get_with_proxy(api_url)
        retry
      else
        puts "Error fetching JSON data from #{api_url}: #{e.message}"
        return {}
      end
    end
  end

  def url_valid?(url)
    response = get_response(url)
    response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPMovedPermanently)
  end
end
