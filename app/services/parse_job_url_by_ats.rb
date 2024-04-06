class ParseJobUrlByAts
  include AtsDetector

  attr_reader :string

  def initialize(url)
    @string = url
  end

  def parse(list = nil)
    return p "ATS not found in ATS_SYSTEM_PARSER - #{@string}" unless (ats = determine_ats(@string))

    if SUPPORTED_ATS_SYSTEMS.include?(ats.name)
      ats_identifier, job_id = list ? ats.parse_url(@string, list[ats.name]) : ats.parse_url(@string)
      [ats, ats_identifier, job_id]
    elsif ats
      p "Job url skipped as #{ats.name} not yet setup - #{@string}"
      ats
    else
      p "Could not find ATS for job url - #{@string}"
    end
  end
end
