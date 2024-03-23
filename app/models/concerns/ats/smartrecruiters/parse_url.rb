module Ats
  module Smartrecruiters
    module ParseUrl
      extend ActiveSupport::Concern
      extend AtsMethods

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{https://jobs\.smartrecruiters\.com/(?<ats_identifier>[^/]+)/(?<job_id>\d+)(?:-[^/]+)?}
          # TODO: Add API parsing for Smartrecruiters
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
