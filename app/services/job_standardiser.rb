class JobStandardiser

  def initialize(job)
    @job = job
  end

  def standardise_fields
    fetch_role
    fetch_seniority
    fetch_location
    @job.save
    p "New location is: #{@job.location}"
    p "City is: #{@job.city}"
    p "Country is: #{@job.country}"
  end

  def fetch_role
    title_roles = []
    roles = []

    title_keywords = {
      /back[- ]?end/ => 'back_end',
      /front[- ]?end/ => 'front_end',
      /full[- ]?stack/ => 'full_stack',
      /devops/ => 'dev_ops',
      /\bqa\b/ => 'qa_test_engineer',
      /\btest\b/ => 'qa_test_engineer',
      /mobile/ => 'mobile',
      /\bios\b/ => 'mobile',
      /android/ => 'mobile',
      /react native/ => 'mobile',
      /\bdata\b/ => 'data_engineer'
    }

    key_phrases = {
      /front[- ]?end/ => 'front_end',
      /responsive web/ => 'front_end',
      /\breact\b(?!.?native)/ => 'front_end',
      /react native/ => 'mobile',
      /reactjs/ => 'front_end',
      /figma/ => 'front_end',
      /grunt/ => 'front_end',
      /gulp/ => 'front_end',
      /webpack/ => 'front_end',
      /tailwind/ => 'front_end',
      /bootstrap/ => 'front_end',
      /\bcss\b(?!.?careers)|\bsass\b/ => 'front_end',
      /jquery/ => 'front_end',
      /html/ => 'front_end',
      /\bvue\b/ => 'front_end',
      /back[- ]?end/ => 'back_end',
      /server[- ]side/ => 'back_end',
      /cloud computing/ => 'back_end',
      /database/ => 'back_end',
      /sql\b/ => 'back_end',
      /laravel/ => 'back_end',
      /kubernetes/ => 'back_end',
      /docker/ => 'back_end',
      /\baws\b/ => 'back_end',
      /azure/ => 'back_end',
      /\bgcp\b|google cloud/ => 'back_end',
      /\bnode\b/ => 'back_end',
      /full[- ]?stack/ => 'full_stack',
      /mobile/ => 'mobile',
      /\bios\b/ => 'mobile',
      /android/ => 'mobile',
    }

    title_keywords.each do |keyword, role|
      title_roles << role if @job.job_title.downcase.match(keyword)
    end

    key_phrases.each do |phrase, role|
      roles << role if @job.job_description.downcase.match?(phrase)
    end

    if title_roles.include?('front_end')
      roles.delete('full_stack')
      roles.delete('back_end')
    elsif title_roles.include?('back_end')
      roles.delete('full_stack')
      roles.delete('front_end')
    end

    roles += title_roles
    roles.uniq!

    if roles.include?('full_stack') || (roles.include?('front_end') && roles.include?('back_end'))
      roles.delete('front_end')
      roles.delete('back_end')
    end

    @job.role = roles.join('&&')
  end

  def fetch_seniority
    seniority_levels = {
      /intern/ => 'Internship',
      /graduate/ => 'Entry-Level',
      /junior/ => 'Junior',
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

    experience_levels_digits = {
      1..2 => 'Junior',
      3..4 => 'Mid-Level',
      5..30 => 'Senior'
    }

    experience_levels_letters = {
      'one' => 'Junior',
      'two' => 'Junior',
      'three' => 'Mid-Level',
      'four' => 'Mid-Level',
      'five' => 'Senior',
      'ten' => 'Senior'
    }

    key_phrases = {
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

    seniority_levels.each do |keyword, level|
      @job.seniority = level if @job.job_title.downcase.match?(keyword)
    end
    return if @job.seniority

    years_experience = @job.job_description.downcase.scan(/(\d+)\s*(?:-|\s(?:to)?\s|\sto\s)?\s*\d*\+? year.{0,40} experience/).flatten.map(&:to_i).max
    @job.seniority = experience_levels_digits.find { |k, v| break v if k.cover?(years_experience) } if years_experience
    return if @job.seniority

    years_experience = @job.job_description.downcase.match(/(one|two|three|four|five|ten)(?:[ -]plus| ?\+)? year.{0,40} experience/)
    @job.seniority = experience_levels_letters[years_experience[1]] if years_experience
    return if @job.seniority

    key_phrases.each do |phrase, level|
      @job.seniority = level if @job.job_description.downcase.match(phrase)
    end
  end

  def fetch_location
    if @job.location
      p "Original location was: #{@job.location}"
      location = @job.location
      hybrid = location.downcase.include?('hybrid')
      remote = location.downcase.match?(/(?<!\bor\s)remote/)

      location_elements = location.split(',').map { |element| element.gsub(/[-;(\/].*/, '').gsub(/([Rr]emote|[Hh]ybrid)\s*[,;:-]?\s*/, '').strip }
      @job.location = location_elements.reject(&:empty?).join(', ')

      @job.hybrid = hybrid
      @job.remote_only = remote && !hybrid

      @job.location = @job.country if @job.location.empty?
      @job.location += " (Remote)" if @job.remote_only
    end
  end
end
