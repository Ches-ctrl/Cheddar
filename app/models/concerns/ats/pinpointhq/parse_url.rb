module Ats
  module Pinpointhq
    module ParseUrl
      extend AtsMethods

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://(?<company_name>[\w%-]+)\.pinpointhq\.com(?:/en/postings/(?<job_id>[a-f\d-]+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
