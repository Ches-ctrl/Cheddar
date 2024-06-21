module Ats
  module Workday
    module ParseUrl
      def parse_url(url, _saved_ids = nil)
        # TODO: write the proper regex here
        regex_formats = [
          %r{https://(?<tenant>[\w-]+)\.wd(?<version>\d+)\.myworkday[\w]+\.com/(?:en-US/)?(?<site_id>[\w-]+)(?:/(?:.+)/(?<job_id>[\w-]+)(?:\?[^/]+)?$)?}
        ]
        parse_workday_url(url, regex_formats)
      end

      private

      def parse_workday_url(url, regex_formats)
        regex_formats.each do |regex|
          next unless (match = url.match(regex))

          tenant, version, site_id, job_id = match.captures
          ats_identifier = "#{tenant}/#{site_id}/#{version}"
          return [ats_identifier, job_id]
        end
        nil
      end
    end
  end
end
