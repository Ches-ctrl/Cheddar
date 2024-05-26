module Ats
  module UrlParser
    extend ActiveSupport::Concern
    # TODO: Refactor this to simplify down

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

    def replace_ats_identifier(ats_identifier)
      api_url = url_api.gsub("XXX", ats_identifier)
      main_url = url_base.gsub("XXX", ats_identifier)

      [api_url, main_url]
    end
  end
end
