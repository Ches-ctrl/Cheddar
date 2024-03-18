module Ats::Ashbyhq::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    regex_formats = [
      %r{https://jobs\.ashbyhq\.com/(?<company_name>[^/]+)/(?<job_id>[^/]+)},
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
      %r{://jobs\.ashbyhq\.com/([\w%-]+(?:\.[a-z]{2,3})?)$}
    ]

    regex_formats.each do |regex|
      match = url.match(regex)
      return match[1] if match
    end

    return
  end
end
