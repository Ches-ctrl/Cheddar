class JobUrl
  include Constants

  attr_reader :string

  def initialize(url)
    @string = url
  end

  def parse
    return unless (ats = fetch_ats)

    ats_identifier, job_id = ats.parse_url.call(@string)
    [ats, ats_identifier, job_id]
  end

  def fetch_ats
    name = ATS_SYSTEM_PARSER.find { |k, v| break v if @string.match?(k) }
    return ApplicantTrackingSystem.find_by(name:)
  end
end
