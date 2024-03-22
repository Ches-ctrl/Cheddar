module Ats
  module Recruitee
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url)
        regex_formats = [
          %r{https://(?<company_name>[^.]+)\.recruitee\.com(?:/o/(?<job_slug>[^/]+)(?:/c/new)?)?}
        ]

        regex_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return block_given? ? yield(ats_identifier) : [ats_identifier, job_id]
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
  end
end
