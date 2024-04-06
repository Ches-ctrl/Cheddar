class ParseJobUrlByAts
  include Constants

  attr_reader :string

  def initialize(url)
    @string = url
  end

  def parse(list = nil)
    return unless (ats = fetch_ats)

    ats_identifier, job_id = list ? ats.parse_url(@string, list[ats.name]) : ats.parse_url(@string)
    [ats, ats_identifier, job_id]
  end

  def fetch_ats
    name = ATS_SYSTEM_PARSER.find { |regex, ats_name| break ats_name if @string.match?(regex) }
    return ApplicantTrackingSystem.find_by(name:)
  end
end
