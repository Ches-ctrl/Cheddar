module Ats
  module Manatal
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        regex_formats = [
          %r{https://www\.careers-page\.com/(?<company_name>[^/]+)(?:/job/(?<job_id>[^/]+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
