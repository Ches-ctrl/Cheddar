module Ats
  module Recruitee
    module ParseUrl
      extend ActiveSupport::Concern
      extend AtsMethods

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://(?<company_name>[^.]+)\.recruitee\.com(?:/o/(?<job_slug>[^/]+)(?:/c/new)?)?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
