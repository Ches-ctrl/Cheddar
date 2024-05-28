class ApplicationService
  # TODO: Implement these core helper classes once we've checked for no unintended consequences
  # def self.call(*args, &block)
  #   new(*args, &block).call
  # end

  private

  # TODO: Add custom user_agent, timeout, proxies, and retries
  def fetch_json(url)
    response = Faraday.get(url)
    JSON.parse(response.body)
  rescue Faraday::Error => e
    Rails.logger.error "HTTP request failed: #{e.message}"
    nil
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse JSON: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "An unexpected error occurred: #{e.message}"
    nil
  end

  def fetch_xml(url)
    response = Faraday.get(url)
    Nokogiri::XML(response.body)
  rescue Faraday::Error => e
    Rails.logger.error "HTTP request failed: #{e.message}"
    nil
  rescue Nokogiri::XML::SyntaxError => e
    Rails.logger.error "Failed to parse XML: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "An unexpected error occurred: #{e.message}"
    nil
  end

  def stream_xml(url)
    response = Faraday.get(url)
    Nokogiri::XML::Reader(response.body)
  rescue Faraday::Error => e
    Rails.logger.error "HTTP request failed: #{e.message}"
    nil
  rescue Nokogiri::XML::SyntaxError => e
    Rails.logger.error "Failed to parse XML: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "An unexpected error occurred: #{e.message}"
    nil
  end
end
