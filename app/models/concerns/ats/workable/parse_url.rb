module Ats
  module Workable
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://apply\.workable\.com/([^/]+)(?:/j/([^/]+))?},
          %r{https://apply\.workable\.com/api/v1/accounts/([^/]+)(?:/jobs/([^/?]+)(?:\?.*)?)?}
        ]
        # TODO: handle redirects
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
