module Ats::Lever::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    regex_formats = [
      %r{https://jobs\.lever\.co/(?<company_name>[^/]+)/(?<job_id>[^/]+)},
      %r{https://jobs\.eu\.lever\.co/(?<company_name>[^/]+)/(?<job_id>[^/]+)},
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
      %r{://jobs\.lever\.co/([\w%-]+(?:\.[a-z]{2,3})?)$}
    ]

    regex_formats.each do |regex|
      match = url.match(regex)
      return match[1] if match
    end

    return
  end
end
