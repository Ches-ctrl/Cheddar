module Ats
  module Bamboohr
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        regex_formats = [
          %r{://(?<company_name>[\w%-]+)\.bamboohr\.com(?:/careers/(?<job_id>\d+))?},
          %r{://(?<company_name>[\w%-]+)\.bamboohr\.com(?:/jobs/view.php\?id=(?<job_id>\d+))?}
        ]

        try_standard_formats(url, regex_formats)
      end
    end
  end
end
