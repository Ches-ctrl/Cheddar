module Ats
  module UrlParser
    extend ActiveSupport::Concern

    def parse_url(url)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def fetch_embedded_job_id(url)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    private

    def try_standard_formats(url, regex_formats)
      regex_formats.each do |regex|
        next unless (match = url.match(regex))

        ats_identifier, job_id = match.captures
        return [ats_identifier, job_id]
      end
      nil
    end
  end
end
