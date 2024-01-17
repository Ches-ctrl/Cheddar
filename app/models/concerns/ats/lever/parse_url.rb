module Ats::Lever::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    regex_formats = [
      %r{https://jobs\.lever\.co/(?<company_name>[^/]+)/(?<job_id>[^/]+)},
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
