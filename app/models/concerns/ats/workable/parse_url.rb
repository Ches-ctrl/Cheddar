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
end
