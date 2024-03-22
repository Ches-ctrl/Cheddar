module Ats
  module Greenhouse
    module ParseUrl
      extend ActiveSupport::Concern
      extend ValidUrl
      extend AtsMethods
      extend CompanyCsv

      # TODO: Possible to combine this for all ATS systems and make it more DRY?
      def self.call(url, saved_ids = nil)
        # Doesn't yet handle urls without a job_id due to conflict with embedded urls
        regex_formats = [
          %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/([^/]+)(?:/jobs/(\d+))?},
          %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?for=([^&]+)(?:&token=(\d+))?},
          %r{https://boards-api\.?[a-zA-Z]*\.greenhouse\.io(?:/v1/boards)?/([^/]+)(?:/jobs/(\d+))?}
        ]

        alt_formats = [
          %r{://(?:[^.]+\.)?([^.]+)\.[a-z]{2,4}[./](?:.*gh_jid=(\d+))?}
        ]

        regex_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id]
        end

        alt_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id] if confirm(ats_identifier, saved_ids)
        end
        return nil
      end

      def self.confirm(potential_identifier, saved_ids)
        # TODO: In production, Company.all and not ats_list will be single source of truth.
        saved_ids ||= ats_list[this_ats.name]
        return true if saved_ids.include?(potential_identifier)

        puts "\nTesting the ats_identifier: #{potential_identifier}"
        url = "#{base_url_api}#{potential_identifier}/"
        return potential_identifier if valid?(url)

        puts "the identifier was invalid."
        return
      end
    end
  end
end
