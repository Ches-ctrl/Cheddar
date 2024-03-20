module Ats
  module Lever
    module ParseUrl
      extend ActiveSupport::Concern

      def self.parse_url(url)
        regex_formats = [
          %r{https://jobs\.lever\.co/(?<company_name>[^/]+)/(?<job_id>[^/]+)}
        ]

        regex_formats.each do |regex|
          match = url.match(regex)
          return nil unless match

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id]
        end
      end
    end
  end
end
