module Ats
  module Workable
    module ParseUrl
      extend ActiveSupport::Concern
      extend AtsMethods

      def self.call(url, _saved_ids = nil)
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
