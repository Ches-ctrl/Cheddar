module Standardizer
  class SeniorityStandardizer
    include Constants

    # TODO: Update levels so that we have internships and graduate

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
      return if @job.seniority

      SENIORITY_TITLES.each do |keyword, level|
        return @job.seniority = level if @job.title.downcase.match?(keyword)
      end

      years_experience = @job.description&.downcase&.scan(/(\d+)\s*(?:-|\s(?:to)?\s|\sto\s)?\s*\d*\+? year.{0,40} experience/)&.flatten&.map(&:to_i)&.max
      return if years_experience && (@job.seniority = EXPERIENCE_DIGITS.find do |k, v|
                                       break v if k.cover?(years_experience)
                                     end)

      years_experience = @job.description&.downcase&.match(/(one|two|three|four|five|ten).{0, 12} year.{0,40} experience/)
      return if years_experience && (@job.seniority = EXPERIENCE_WRITTEN_NUMBERS[years_experience[1]])

      SENIORITY_DESCRIPTORS.each do |phrase, level| # will return the highest level matched
        @job.seniority = level if @job.description&.downcase&.match?(phrase)
      end
    end
  end
end
