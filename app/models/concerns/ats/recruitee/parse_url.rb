module Ats
  module Recruitee
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://(?<company_name>[^.]+)\.recruitee\.com(?:/o/(?<job_slug>[^/]+)(?:/c/new)?)?}
        ]

        regex_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id]
        end
        return nil
      end
    end
  end
end
