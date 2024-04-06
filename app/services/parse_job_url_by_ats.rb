class ParseJobUrlByAts
  include AtsDetector

  attr_reader :string

  def initialize(url)
    @string = url
  end

  def parse(list = nil)
    return "" unless (ats = determine_ats(@string))

    if SUPPORTED_ATS_SYSTEMS.include?(ats.name)
      ats_identifier, job_id = list ? ats.parse_url(@string, list[ats.name]) : ats.parse_url(@string)
      [ats, ats_identifier, job_id]
    elsif ats
      ats
    else
      @string
    end
  end
end
