class SeniorityStandardizer
  SENIORITY_TITLES = {
    /intern/ => 'Internship',
    /graduate/ => 'Entry-Level',
    /junior/ => 'Junior',
    /early[- ]?career/ => 'Junior',
    /\bi\b/ => 'Junior',
    /\bmid\b/ => 'Mid-Level',
    /mid-?weight/ => 'Mid-Level',
    /mid-?level/ => 'Mid-Level',
    /\bii\b/ => 'Mid-Level',
    /\biii\b/ => 'Mid-Level',
    /senior/ => 'Senior',
    /\blead\b/ => 'Senior',
    /principal/ => 'Senior',
    /staff/ => 'Senior'
  }
  SENIORITY_DESCRIPTORS = {
    /track record of/ => 'Junior',
    /(commercial|professional|production|significant) experience(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /proficien(cy|t) (in|with) (?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /deep.{0,28} (knowledge|expertise)(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /experience (in|with).{0,50} (commercial|professional)/ => 'Mid-Level',
    /experience.{3,28} non-internship/ => 'Mid-Level',
    /(mid-level|intermediate).{0,28} (developer|engineer)/ => 'Mid-Level',
    /extensive experience(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Senior',
    /(seasoned|senior).{0,28} (developer|engineer)/ => 'Senior',
    /expert\b/ => 'Senior'
  }
  EXPERIENCE_DIGITS = {
    1..2 => 'Junior',
    3..4 => 'Mid-Level',
    5..30 => 'Senior'
  }
  EXPERIENCE_WRITTEN_NUMBERS = {
    'one' => 'Junior',
    'two' => 'Junior',
    'three' => 'Mid-Level',
    'four' => 'Mid-Level',
    'five' => 'Senior',
    'ten' => 'Senior'
  }

  def initialize(job)
    @job = job
  end

  def standardize
    SENIORITY_TITLES.each do |keyword, level|
      return @job.seniority = level if @job.job_title.downcase.match?(keyword)
    end

    years_experience = @job.job_description.downcase.scan(/(\d+)\s*(?:-|\s(?:to)?\s|\sto\s)?\s*\d*\+? year.{0,40} experience/).flatten.map(&:to_i).max
    return if years_experience && (@job.seniority = EXPERIENCE_DIGITS.find do |k, v|
                                     break v if k.cover?(years_experience)
                                   end)

    years_experience = @job.job_description.downcase.match(/(one|two|three|four|five|ten).{0, 12} year.{0,40} experience/)
    return if years_experience && (@job.seniority = EXPERIENCE_WRITTEN_NUMBERS[years_experience[1]])

    SENIORITY_DESCRIPTORS.each do |phrase, level| # will return the highest level matched
      @job.seniority = level if @job.job_description.downcase.match?(phrase)
    end
  end
end
