module Ats::Recruitee::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    regex_formats = [
      %r{https://(?<company_name>[^.]+)\.recruitee\.com/o/(?<job_slug>[^/]+)(?:/c/new)?},
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
