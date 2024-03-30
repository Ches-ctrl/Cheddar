module Ats
  module Workable
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        regex_formats = [
          %r{https://apply\.workable\.com/([^/]+)(?:/j/([^/]+))?},
          %r{https://apply\.workable\.com/api/v1/accounts/([^/]+)(?:/jobs/([^/?]+)(?:\?.*)?)?}
        ]
        # TODO: handle redirects
        try_standard_formats(url, regex_formats)
      end
    end
  end
end
