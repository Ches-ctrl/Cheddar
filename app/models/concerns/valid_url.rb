module ValidUrl
  extend ActiveSupport::Concern

  def valid?(url, max_retries = 2)
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
    !response.is_a?(Net::HTTPNotFound)
  end
end
