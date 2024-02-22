class JobStandardiser

  COUNTRIES = {
    'bay area' => 'United States',
    'london' => 'UK',
    'uk' => 'UK',
    'united kingdom' => 'UK',
    'united states' => 'United States',
    'us' => 'United States',
    'usa' => 'United States'
  }

  STATES = {
    'england' => nil
  }

  def initialize(job)
    @job = job
  end

  def standardise_fields
    # location
    if @job.location
      location = @job.location.downcase
      hybrid = location.include?('hybrid')
      remote = location.include?('remote')
      location_elements = location.split(',').map { |element| element.gsub(/[(\/].*/, '').strip }
      p "JobStandardiser: #{location_elements}"
      case location_elements.size
      when 1
        city = location_elements[0]
      when 2
        city, country = location_elements
      when 3
        city, state, country = location_elements
      else
        city, state = location_elements[0..1]
        country = location_elements[2..]
      end
      country = country ? COUNTRIES[country] : COUNTRIES[city]
      state = STATES[state]
      city = city.split.map(&:capitalize).join(' ')

      @job.location = [city, state, country].compact.join(', ')
      @job.hybrid = hybrid
      @job.remote = remote

    end
    @job.save
    p "JobStandardiser: #{@job.location}"
  end
end
