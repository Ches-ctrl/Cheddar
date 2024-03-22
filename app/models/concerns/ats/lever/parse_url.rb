module Ats
  module Lever
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://jobs\.lever\.co/(?<company_name>[^/]+)(?:/(?<job_id>[^/?]+))?},
          %r{https://jobs\.eu\.lever\.co/(?<company_name>[^/]+)(?:/(?<job_id>[^/?]+))?}
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
