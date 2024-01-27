module Ats::Smartrecruiters::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    regex_formats = [
      %r{https://jobs\.smartrecruiters\.com/(?<ats_identifier>[^/]+)/(?<job_id>\d+)-[^/]+},
    ]

    regex_formats.each do |regex|
      match = url.match(regex)
      p match
      if match
        ats_identifier, job_id = match.captures
        return [ats_identifier, job_id]
      else
        return nil
      end
    end
  end
end
