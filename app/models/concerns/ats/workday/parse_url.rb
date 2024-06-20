module Ats
  module Workday
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        # TODO: write the proper regex here
        regex_formats = [
          %r{https://([^/]+)\.wd(\d+)\.myworkday(?=[^/]+)\.com/(?=en-US/)?([^/]+)/}
        ]
        try_standard_formats(url, regex_formats)
      end
    end
  end
end
