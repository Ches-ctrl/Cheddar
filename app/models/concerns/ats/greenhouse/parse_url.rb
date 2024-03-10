module Ats
  module Greenhouse
    module ParseUrl
      extend ActiveSupport::Concern

      # TODO: Possible to combine this for all ATS systems and make it more DRY?

      def self.parse_url(url)
        # Doesn't yet handle urls without a job_id due to conflict with embedded urls
        regex_formats = [
          %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/([^/]+)/jobs/(\d+)},
          %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?for=([^&]+)&token=(\d+)},
          %r{https://boards-api\.?[a-zA-Z]*\.greenhouse\.io(?:/v1/boards)?/([^/]+)/jobs/(\d+)}
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
    end
  end
end
