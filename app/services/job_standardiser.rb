class JobStandardiser

  def initialize(job)
    @job = job
  end

  def standardise_fields
    # seniority
    seniority_levels = {
      'intern' => 'Internship',
      'graduate' => 'Entry-Level',
      'junior' => 'Junior',
      ' i' => 'Junior',
      'mid-level' => 'Mid-Level',
      ' ii' => 'Mid-Level',
      ' iii' => 'Mid-Level',
      'senior' => 'Senior',
      'lead' => 'Senior',
      'principal' => 'Senior',
      'staff' => 'Senior'
    }

    experience_levels = {
      1..2 => 'Junior',
      3..4 => 'Mid-Level',
      5..30 => 'Senior'
    }

    key_phrases = {
      /proficien(cy|t) in/ => 'Mid-Level',
      /seasoned.{0,28} (developer|engineer)/ => 'Senior'
    }

    seniority_levels.each do |keyword, level|
      @job.seniority = level if @job.job_title.downcase.include?(keyword)
    end

    unless @job.seniority
      years_experience = @job.job_description.downcase.scan(/(\d)\+? years.{0,28} experience/).flatten.map(&:to_i).max
      @job.seniority = experience_levels.find { |k, v| break v if k.cover?(years_experience) } if years_experience
    end

    unless @job.seniority
      key_phrases.each do |phrase, level|
        @job.seniority = level if @job.job_description.downcase.match(phrase)
      end
    end

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
  end
end
