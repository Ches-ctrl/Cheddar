module CheckUrlIsValid
  extend ActiveSupport::Concern

  # TODO: This doesn't yet work sufficiently well - often you'll have a successfull or redirect HTTP call but an error message on the page so will need parsing by Nokogiri with a regex for the error message

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
    rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError => e
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

    p response
    return response
  end

  def get_json_data(api_url)
    response = get(api_url)
    begin
      JSON.parse(response)
    rescue JSON::ParserError => e
      puts "Error fetching JSON data from #{api_url}: #{e.message}"
      return {}
    end
  end

  def url_valid?(url)
    response = get_response(url)
    response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPMovedPermanently)
  end
end
