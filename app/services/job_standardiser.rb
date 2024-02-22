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

      location_elements = location.split(',').map { |element| element.gsub(/[(\/].*/, '').strip.split.map(&:capitalize).join(' ') }
      @job.location = location_elements.join(', ')

      @job.hybrid = hybrid
      @job.remote_only = remote && !hybrid

    end
    @job.save
    p "JobStandardiser: #{@job.location}"
  end
end
