module FaradayHelpers
  def faraday_request(details)
    endpoint = details[:endpoint]
    verb = details[:verb] || :get
    options = details[:options] || {}
    fetch_json(endpoint, verb, options)
  end

  def fetch_json(url, verb = :get, options = {})
    fetch_data(url, :parse_json, verb, options)
  end

  def fetch_xml(url, verb = :get, options = {})
    fetch_data(url, :parse_xml, verb, options)
  end

  def stream_xml(url, verb = :get, options = {})
    fetch_data(url, :stream_xml_data, verb, options)
  end

  private

  # TODO: Add custom user_agent, timeout, proxies, and retries
  # TODO: Add block handling for stream_xml

  def fetch_data(url, parse_method, verb = :get, options = {})
    response = Faraday.send(verb, url, options) do |request|
      request.params = options[:params] || {}
      request.headers = options[:headers] || {}
      request.body = options[:body]
    end
    send(parse_method, response.body)
  end

  def parse_json(body)
    JSON.parse(body)
  end

  def parse_xml(body)
    Nokogiri::XML(body)
  end

  def stream_xml_data(body)
    Nokogiri::XML::Reader(body)
  end

  def log_error(message)
    Rails.logger.error(message)
  end

  def pretty_generate(json)
    JSON.pretty_generate(json)
  end
end
