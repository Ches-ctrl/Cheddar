module Ats::Greenhouse::ParseUrl
  extend ActiveSupport::Concern

  def self.parse_url(url)
    # Doesn't yet handle urls without a job_id due to conflict with embedded urls
    regex_formats = [
      %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/([^/]+)/jobs/(\d+)},
      %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?for=([^&]+)&token=(\d+)},
      %r{https://boards-api\.?[a-zA-Z]*\.greenhouse\.io(?:/v1/boards)?/([^/]+)/jobs/(\d+)},
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
