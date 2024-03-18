require 'cgi'

class LocationStandardizer
  def initialize(job)
    @job = job
  end

  def standardize
    return unless @job.non_geocoded_location_string

    location = @job.non_geocoded_location_string
    hybrid = location.downcase.include?('hybrid') || @job.job_description.downcase.include?('hybrid')
    # remote = location.downcase.match?(/(?<!\bor\s)remote/)

    location_elements = location.split(/[,•&]/).map { |element| element.gsub(/[-;(\/]/, '').gsub(/remote|hybrid|\bn\/?a\b/i, '').strip }

    # search for existing cities and countries in location elements:
    location_elements.each do |element|
      city_string, country_string, latitude, longitude = standardize_city_and_country(element)

      next unless country_string

      country = Country.find_or_create_by(name: country_string)
      @job.countries << country unless @job.countries.include?(country)

      next unless city_string

      location = Location.find_or_create_by(city: city_string, country:, latitude:, longitude:)
      @job.locations << location unless @job.locations.include?(location)
      # country = join_attribute({ name: country_string }, Country, JobsCountry)
      # join_attribute({ city: city_string, country:, latitude:, longitude: }, Location, JobsLocation)
    end

    @job.hybrid = hybrid
    @job.remote_only = @job.locations.empty?
  end

  private

  def standardize_city_and_country(string)
    ascii_string = convert_to_ascii(string)
    puts ascii_string
    api_url = "http://dev.virtualearth.net/REST/v1/Locations/#{ascii_string}?key=#{ENV['BING_API_KEY']}"

    begin
      uri = URI(api_url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
    rescue JSON::ParserError, Net::HTTPError => e
      puts "Error fetching data: #{e.message}"
      return []
    end

    return [] if data['resourceSets'][0]['estimatedTotal'].zero?

    city = data['resourceSets'][0]['resources'][0]['address']['locality']
    country = data['resourceSets'][0]['resources'][0]['address']['countryRegion']
    latitude, longitude = data['resourceSets'][0]['resources'][0]['point']['coordinates']
    return [city, country, latitude, longitude]
  end

  def convert_to_ascii(string)
    CGI.escape(string).gsub("+", "%20")
  end
end
