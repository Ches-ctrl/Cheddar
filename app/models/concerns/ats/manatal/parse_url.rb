module Ats
  module Manatal
    module ParseUrl
      extend ActiveSupport::Concern
      extend AtsMethods

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://www\.careers-page\.com/(?<company_name>[^/]+)(?:/job/(?<job_id>[^/]+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
