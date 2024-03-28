module ValidUrl
  extend ActiveSupport::Concern

  def get_response(url, max_retries = 2)
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

  def get(url, retries = 2)
    uri = URI(url)
    error = nil
    retries.times do |attempt|
      response = Net::HTTP.get(uri)
      return response
    rescue Errno::ECONNRESET, OpenSSL::SSL::SSLError => e
      error = e
      sleep 2 ** (attempt + 1) # Exponential backoff
      retry
    end
    puts "Failed after #{retries} retries: #{error.message}"
    return nil
  end

  def valid?(url)
    response = get_response(url)
    !response.is_a?(Net::HTTPNotFound)
  end
end
