module Ats
  module Pinpointhq
    module ParseUrl
      extend ActiveSupport::Concern

      def self.parse_url(url)
        regex_formats = [
          %r{https://(?<company_name>[\w%-]+)\.pinpointhq\.com/en/postings/(?<job_id>[a-f\d-]+)},
        ]

        regex_formats.each do |regex|
          match = url.match(regex)
          return nil unless match

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id]
        end
      end

      def self.parse_ats_identifier(url)
        ats_identifier, _job_id = parse_url(url)
        return ats_identifier if ats_identifier

        regex_formats = [
          %r{://([\w%-]+)\.pinpointhq\.com}
        ]

        regex_formats.each do |regex|
          match = url.match(regex)
          return match[1] if match
        end

        return
      end
    end
  end
end
