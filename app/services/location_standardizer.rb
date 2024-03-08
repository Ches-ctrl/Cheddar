class LocationStandardizer

  def initialize(job)
    @job = job
  end

  def standardize
    return unless @job.non_geocoded_location_string

    location = @job.non_geocoded_location_string
    hybrid = location.downcase.include?('hybrid') || @job.job_description.downcase.include?('hybrid')
    remote = location.downcase.match?(/(?<!\bor\s)remote/)

    location_elements = location.split(/[,•]/).map { |element| element.gsub(/[-;(\/].*/, '').gsub(/([Rr]emote|[Hh]ybrid)\s*[,;:-]?\s*/, '').strip }

    # search for existing cities and countries in location elements:
    location_elements.each do |element|
      city_string, country_string, latitude, longitude = standardize_city_and_country(element)
      # what if response is nil?
      if city_instance = Location.find_by(city: city_string)
        JobsLocation.create!(job: @job, location: city_instance)
      elsif country_instance = Country.find_by(name: country_string)
        JobsCountry.create!(job: @job, country: country_instance)
      else
        puts city_string, country_string
        # create new country
        country_instance = Country.create!(name: country_string)
        JobsCountry.create!(job: @job, country: country_instance)
        # create new location
        if city_string
          city_instance = Location.create!(city: city_string, country: country_instance, latitude: latitude, longitude: longitude)
          JobsLocation.create!(job: @job, location: city_instance)
        end
      end
      location_elements.delete(element)
    end

    @job.hybrid = hybrid
    @job.remote_only = remote && !hybrid

    # @job.location = @job.country if @job.location.empty?
    # @job.location += " (Remote)" if @job.remote_only
  end

  private

  def standardize_city_and_country(string)
    string.gsub!(' ', '%20')
    api_url = "http://dev.virtualearth.net/REST/v1/Locations/#{string}?key=#{ENV['BING_API_KEY']}"

    begin
      uri = URI(api_url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
    rescue JSON::ParserError, Net::HTTPError => e
      puts "Error fetching data: #{e.message}"
      return []
    end
    city = data['resourceSets'][0]['resources'][0]['address']['locality']
    country = data['resourceSets'][0]['resources'][0]['address']['countryRegion']
    latitude, longitude = data['resourceSets'][0]['resources'][0]['point']['coordinates']
    return [city, country, latitude, longitude]
  end
end
