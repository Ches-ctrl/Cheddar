module Ats
  module Bamboohr
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url, _saved_ids = nil)
        regex_formats = [
          %r{://(?<company_name>[\w%-]+)\.bamboohr\.com(?:/careers/(?<job_id>\d+))?},
          %r{://(?<company_name>[\w%-]+)\.bamboohr\.com(?:/jobs/view.php\?id=(?<job_id>\d+))?}
        ]

        regex_formats.each do |regex|
          match = url.match(regex)
          if match
            ats_identifier, job_id = match.captures
            return [ats_identifier, job_id]
          end
        end
        return nil
      end
    end
  end
end
