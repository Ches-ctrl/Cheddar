module CheckUrlIsValid
  extend ActiveSupport::Concern

  # TODO: This doesn't yet work sufficiently well - often you'll have a successfull or redirect HTTP call but an error message on the page so will need parsing by Nokogiri with a regex for the error message

  def job_is_live?(url)
    response = get_response(url)
    p "Response: #{response}"
    response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
  end

  def get_response(url, max_retries = 1)
    uri = URI(url)
    retries = 0
    begin
      response = Net::HTTP.get_response(uri)
    rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError => e
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

  def get(url, retries = 1)
    uri = URI(url)
    retries.times do |attempt|
      response = Net::HTTP.get(uri)
      return response
    rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError => e
      sleep 2 ** (attempt + 1) # Exponential backoff
      retry
    rescue Net::HTTPError => e
      puts "Failed to load #{url}: #{e.message}" # Don't retry
      return nil
    end
    puts "Failed after #{retries} retries: #{error.message}"
    return nil
  end

  def get_json_data(api_url)
    response = get(api_url)
    begin
      JSON.parse(response)
    rescue JSON::ParserError => e
      p response
      puts "Error fetching JSON data from #{api_url}: #{e.message}"
      return {}
    end
  end

  def url_valid?(url)
    response = get_response(url)
    response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPMovedPermanently)
  end
end
