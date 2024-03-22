module Ats
  module Greenhouse
    module ParseUrl
      extend ActiveSupport::Concern
      extend ValidUrl
      extend AtsMethods

      # TODO: Possible to combine this for all ATS systems and make it more DRY?
      def self.call(url)
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
          return [ats_identifier, job_id] if ats_identifier
        end

        alt_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id] if confirm(ats_identifier)
        end
        return nil
      end

      def self.confirm(potential_identifier)
        puts "\nTesting the ats_identifier: #{potential_identifier}"
        url = "#{base_url_api}#{potential_identifier}/"
        return potential_identifier if valid?(url)

        puts "the identifier was invalid."
        return
      end

      # def self.parse_ats_identifier(url)
      #   ats_identifier, _job_id = parse_url(url)
      #   return ats_identifier if ats_identifier

      #   regex_formats = [
      #     %r{://boards\.greenhouse\.io/([\w%-]+)$},
      #     %r{://boards\.eu\.greenhouse\.io/([\w%-]+)$}, # .eu could be any region
      #     %r{://boards\.greenhouse\.io/embed/job_board(?:/js)?\?for=([\w%-]+)$}
      #   ]
      #   regex_formats.each do |regex|
      #     match = url.match(regex)
      #     return match[1] if match
      #   end

      #   match = url.match(%r{://(?:www\.|ats\.|careers\.)?([^.]*)\.[a-z]{2,4}[./]})
      #   if match
      #     potential_identifier = match[1]
      #     puts "\nTesting the ats_identifier: #{potential_identifier}"
      #     url = "https://boards-api.greenhouse.io/v1/boards/#{potential_identifier}/"
      #     return potential_identifier if valid?(url)

      #     puts "the identifier was invalid."
      #   end
      #   return
      # end
    end
  end
end
