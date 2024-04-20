class JobUrl
  include Constants

  # TODO: Delete this as we now have CreateJobFromUrl which does the same functionality

  attr_reader :string

  def initialize(url)
    @string = url
  end

  def parse(list = nil)
    return embedded_ats unless (ats = fetch_ats)

    ats_identifier, job_id = list ? ats.parse_url(@string, list[ats.name]) : ats.parse_url(@string)
    [ats, ats_identifier, job_id]
  end

  def fetch_ats
    name = ATS_SYSTEM_PARSER.find { |k, v| break v if @string.match?(k) }
    return ApplicantTrackingSystem.find_by(name:)
  end

  private

  def embedded_ats
    ats_list, ats_identifier, job_id = ScrapeMetaTags.new(@string).call
    return if ats_list.empty?

    ats_list.size == 1 ? [ats_list.first, ats_identifier, job_id] : confirm_ats(ats_list)
  end

  def confirm_ats(list)
    p "Here are the ATS candidates:"
    list.each { |ats| p "  #{ats.name}"}
    # TODO: Confirm or reject each ats on the list with further verification methods, return confirmed_ats or nil
    return
  end
end
