class ParseJobUrlByAts
  include AtsDetector

  attr_reader :string

  def initialize(url)
    @string = url
  end

  def parse(list = nil)
    return unless (ats = determine_ats)

    ats_identifier, job_id = list ? ats.parse_url(@string, list[ats.name]) : ats.parse_url(@string)
    [ats, ats_identifier, job_id]
  end
end
