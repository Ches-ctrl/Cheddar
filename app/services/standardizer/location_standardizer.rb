require 'cgi'

module Standardizer
  class LocationStandardizer
    include Constants
    include CheckUrlIsValid

    def initialize(job)
      @job = job
    end

    def standardize
      return unless @job.non_geocoded_location_string

      location = @job.non_geocoded_location_string
      hybrid = location.downcase.include?('hybrid') || @job.description&.downcase&.include?('hybrid')

      JOB_LOCATION_FILTER_WORDS.each { |filter| location.gsub!(filter, '') }
      location_elements = location.split(/[•;]|&&|or/)
                                  .map do |element|
                                    element.gsub(%r{[.\-;(/]}, '')
                                           .strip
                                  end

      # TODO: revise search to handle full addresses, not just city, country, postal_code
      # search for existing cities and countries in location elements:
      location_elements.each do |element|
        city_string, country_string, latitude, longitude = standardize_city_and_country(element)
        next unless country_string

        country = Country.find_or_create_by(name: country_string)
        @job.countries << country unless @job.countries.include?(country)

        next unless city_string

        location = Location.find_or_create_by(city: city_string, country:, latitude:, longitude:)
        @job.locations << location unless @job.locations.include?(location)

        check_for_multiple_locations(element)
      end

      @job.hybrid = hybrid
      @job.remote ||= @job.locations.empty?
    end

    def simple_standardize(string)
      JOB_LOCATION_FILTER_WORDS.each { |filter| string.gsub!(filter, '') }
      city, country = standardize_city_and_country(string)
      [city, country].reject(&:blank?).join(', ')
    end

    private

    def check_for_multiple_locations(string)
      location_elements = string.split(/, ?/)
      location_elements.each do |element|
        city_string, country_string, latitude, longitude = standardize_city_and_country(element)
        next unless country_string

        if element_is_a_new_city?(element, city_string)
          country = Country.find_or_create_by(name: country_string)
          location = Location.find_or_create_by(city: city_string, country:, latitude:, longitude:)
          @job.locations << location
          @job.countries << country unless @job.countries.include?(country)
        elsif element_is_a_new_country?(element, country_string)
          country = Country.find_or_create_by(name: country_string)
          @job.countries << country
        end
      end
    end

    def element_is_a_new_city?(element, city_string)
      return false unless element && city_string

      is_a_city = element.include?(city_string)
      is_a_new_city = !@job.locations.map(&:city).include?(city_string)
      return is_a_city && is_a_new_city
    end

    def element_is_a_new_country?(element, country_string)
      return false unless element && country_string

      is_a_country = element.include?(country_string)
      is_a_new_country = !@job.countries.map(&:name).include?(country_string)
      return is_a_country && is_a_new_country
    end

    def standardize_city_and_country(string)
      string = eliminate_duplicate_names(string)
      ascii_string = convert_to_ascii(string)
      api_url = "http://dev.virtualearth.net/REST/v1/Locations/#{ascii_string}?key=#{ENV.fetch('BING_API_KEY', nil)}"

      data = get_json_data(api_url)

      return if data.dig('resourceSets', 0, 'estimatedTotal').blank?
      return if data.dig('resourceSets', 0, 'resources', 0, 'confidence') == 'Low'

      city = data.dig('resourceSets', 0, 'resources', 0, 'address', 'locality')
      country = data.dig('resourceSets', 0, 'resources', 0, 'address', 'countryRegion')
      latitude, longitude = data.dig('resourceSets', 0, 'resources', 0, 'point', 'coordinates')
      return [city, country, latitude, longitude]
    end

    def eliminate_duplicate_names(string)
      string.split(/\b ?/).uniq.join(' ').gsub(' , ', ',')
    end

    def convert_to_ascii(string)
      string = string.gsub('&', '')
      CGI.escape(string).gsub("+", "%20")
    end
  end
end
