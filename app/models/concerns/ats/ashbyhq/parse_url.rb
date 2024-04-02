module Ats
  module Ashbyhq
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        regex_formats = [
          %r{https://jobs\.ashbyhq\.com/(?<company_name>[^/]+)(?:/(?<job_id>[^/]+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
