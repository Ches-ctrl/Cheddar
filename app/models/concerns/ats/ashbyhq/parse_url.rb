module Ats
  module Ashbyhq
    module ParseUrl
      extend AtsMethods

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://jobs\.ashbyhq\.com/(?<company_name>[^/]+)(?:/(?<job_id>[^/]+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
