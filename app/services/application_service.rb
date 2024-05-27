class ApplicationService
  # TODO: Implement these core helper classes once we've checked for no unintended consequences
  # def self.call(*args, &block)
  #   new(*args, &block).call
  # end

  private

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
end
