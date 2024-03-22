module ValidUrl
  extend ActiveSupport::Concern

  def get_response(url, max_retries = 2)
    uri = URI(url)
    retries = 0
    begin
      response = Net::HTTP.get_response(uri)
    rescue Errno::ECONNRESET => e
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

  def get(url, max_retries = 2)
    uri = URI(url)
    retries = 0
    begin
      response = Net::HTTP.get(uri)
    rescue Errno::ECONNRESET => e
      retries += 1
      if retries <= max_retries
        sleep(2**retries) # Exponential backoff
        retry
      else
        puts "Failed after #{max_retries} retries: #{e.message}"
        return nil
      end
    end
    return response
  end

  def valid?(url)
    response = get_response(url)
    !response.is_a?(Net::HTTPNotFound)
  end
end
