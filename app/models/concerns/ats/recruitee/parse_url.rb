module Ats
  module Recruitee
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        regex_formats = [
          %r{https://(?<name>[^.]+)\.recruitee\.com(?:/o/(?<job_slug>[^/]+)(?:/c/new)?)?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
