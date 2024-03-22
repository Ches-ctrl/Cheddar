module Ats
  module Bamboohr
    module ParseUrl
      extend ActiveSupport::Concern

      def self.call(url)
        regex_formats = [
          %r{://(?<company_name>[\w%-]+)\.bamboohr\.com(?:/careers/(?<job_id>\d+))?},
          %r{://(?<company_name>[\w%-]+)\.bamboohr\.com(?:/jobs/view.php\?id=(?<job_id>\d+))?}
        ]

        regex_formats.each do |regex|
          match = url.match(regex)
          if match
            ats_identifier, job_id = match.captures
            return block_given? ? yield(ats_identifier) : [ats_identifier, job_id]
          end
        end
        return nil
      end

      def self.parse_ats_identifier(url)
        ats_identifier, _job_id = parse_url(url)
        return ats_identifier if ats_identifier

        regex_formats = [
          %r{://([\w%-]+)\.bamboohr\.com/careers$}
        ]

        regex_formats.each do |regex|
          match = url.match(regex)
          return match[1] if match
        end

        return
      end
    end
  end
end
