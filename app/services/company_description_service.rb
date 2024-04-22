class CompanyDescriptionService
  def self.lookup_company(name, ats_identifier)
    uri = URI("https://api.crunchbase.com/api/v4/autocompletes?query=#{URI.encode_www_form_component(name)}&user_key=#{ENV.fetch('CRUNCHBASE_API_KEY', nil)}")
    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      results = JSON.parse(response.body)
      return unless results['count'].positive?

      top_matches = results['entities'].take(3)

      # TODO: this logic is unnecessary. Just look for an exact match
      match_array = top_matches.map.with_index { |match, index| [compare(ats_identifier, match.dig('identifier', 'permalink')), index, match] }
      match = match_array.min_by { |a, b| [-a, b] }[2]

      # TODO: fix as will no longer work with name rather than name @Dan

      name = match.dig('identifier', 'value')
      return unless name.downcase.gsub(' ', '') == name.downcase.gsub(' ', '')

      description = match['short_description']
      keywords = match.dig('identifier', 'permalink').split('-')
      [description, keywords]
    end
  rescue => e
    Rails.logger.error("Error fetching company info from Crunchbase: #{e.message}")
  end

  private_class_method def self.compare(ats_identifier, candidate_identifier)
    a = ats_identifier.downcase.gsub('_', '-')
    b = candidate_identifier
    i = 0
    j = 0

    while i < a.length && j < b.length
      i += 1 if a[i] == b[j]
      j += 1
    end

    return i
  end
end
