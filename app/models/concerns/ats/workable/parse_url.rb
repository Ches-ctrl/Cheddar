module Ats::Workable::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    regex_formats = [
      %r{https://apply\.workable\.com/([^/]+)/j/([^/]+)/},
      %r{https://apply\.workable\.com/api/v1/accounts/([^/]+)/jobs/([^/?]+)(?:\?.*)?},
    ]

    regex_formats.each do |regex|
      match = url.match(regex)
      if match
        ats_identifier, job_id = match.captures
        return [ats_identifier, job_id]
      else
        return nil
      end
    end
  end

  def self.parse_ats_identifier(url)
    ats_identifier, _job_id = parse_url(url)
    return ats_identifier if ats_identifier

    regex_formats = [
      %r{://apply\.workable\.com/([\w%-]+)$}
    ]

    regex_formats.each do |regex|
      match = url.match(regex)
      return match[1] if match
    end

    return
  end
end
