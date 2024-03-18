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
      end
    end
    return nil
  end

  def self.parse_ats_identifier(url)
    ats_identifier, _job_id = parse_url(url)
    return ats_identifier if ats_identifier

    regex_formats = [
      %r{://([^.]+)\.recruitee\.com}
    ]

    regex_formats.each do |regex|
      match = url.match(regex)
      return match[1] if match
    end

    return
  end
end
