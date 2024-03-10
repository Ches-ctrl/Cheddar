require 'cgi'

class LocationStandardizer
  def initialize(job)
    @job = job
  end

  def standardize
    return unless @job.non_geocoded_location_string

    location = @job.non_geocoded_location_string
    hybrid = location.downcase.include?('hybrid') || @job.job_description.downcase.include?('hybrid')
    remote = location.downcase.match?(/(?<!\bor\s)remote/)

    location_elements = location.split(/[,•]/).map do |element|
      element.gsub(%r{[-;(/]}, '').gsub(%r{remote|hybrid|\bn/?a\b}i, '').strip
    end

    # search for existing cities and countries in location elements:
    location_elements.each do |element|
      city_string, country_string, latitude, longitude = standardize_city_and_country(element)

      if country_string
        if (country_instance = Country.find_by(name: country_string))
          JobsCountry.create!(job: @job, country: country_instance) unless JobsCountry.exists?(job: @job,
                                                                                               country: country_instance)
        else
          # create a new country
          country_instance = Country.create!(name: country_string)
          JobsCountry.create!(job: @job, country: country_instance)
          next unless country_instance
        end
      end

      if city_string
        if (city_instance = Location.find_by(city: city_string))
          JobsLocation.create!(job: @job, location: city_instance) unless JobsLocation.exists?(job: @job,
                                                                                               location: city_instance)
        else
          # create new location
          city_instance = Location.create!(city: city_string, country: country_instance, latitude:,
                                           longitude:)
          JobsLocation.create!(job: @job, location: city_instance)
        end
      end
      # location_elements.delete(element)
    end

    @job.hybrid = hybrid
    @job.remote_only = remote && !hybrid

    # @job.location = @job.country if @job.location.empty?
    # @job.location += " (Remote)" if @job.remote_only
  end

  private

  def standardize_city_and_country(string)
    ascii_string = convert_to_ascii(string)
    puts ascii_string
    api_url = "http://dev.virtualearth.net/REST/v1/Locations/#{ascii_string}?key=#{ENV.fetch('BING_API_KEY', nil)}"

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
