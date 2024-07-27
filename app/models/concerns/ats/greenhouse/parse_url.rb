module Ats
  module Greenhouse
    module ParseUrl
      include CompanyCsv

      def parse_url(url, saved_ids = nil)
        # Doesn't yet handle urls without a job_id due to conflict with embedded urls
        regex_formats = [
          %r{https://(?:job-)?boards\.?[a-zA-Z]*\.greenhouse\.io/(?!embed)([^/]+)(?:/jobs/(\d+))?},
          %r{https://(?:job-)?boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?for=([^&]+)(?:&token=(\d+))?},
          %r{https://(?:job-)?boards-api\.?[a-zA-Z]*\.greenhouse\.io(?:/v1/boards)?/([^/]+)(?:/jobs/(\d+))?},
          %r{https://(?:job-)?boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_board/js\?for=([^&]+)}
        ]

        alt_formats = [
          %r{://(?:[^.]+\.)?([^./]+)\.[a-z]{2,4}[./](?:.*gh_jid=(\d+))?}
        ]

        embedded_formats = [
          %r{://(?:job-)?boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?token=(\d+)}
        ]

        ats_identifier, job_id = try_standard_formats(url, regex_formats)
        return [ats_identifier, job_id] if ats_identifier

        alt_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          next if ats_identifier == 'greenhouse'

          return [ats_identifier, job_id] if confirm(ats_identifier, saved_ids)
        end

        return nil unless url_valid?(url)

        embedded_formats.each do |regex|
          next unless (match = url.match(regex))

          job_id = match[1]
          scrape_embed_page(url).each do |ats_identifier|
            return [ats_identifier, job_id] if confirm(ats_identifier, saved_ids)
          end
        end
        return nil
      end

      def fetch_embedded_job_id(url)
        url.match(/[^\d](\d{7})(?:[^\d]|\b)/)[1]
      end

      private

      def confirm(potential_identifier, saved_ids)
        # TODO: In production, Company.all and not ats_list will be single source of truth.
        saved_ids ||= ats_list[name]
        return true if saved_ids.include?(potential_identifier)

        puts "\nTesting the ats_identifier: #{potential_identifier}"
        url = "#{url_api}#{potential_identifier}/"
        return potential_identifier if url_valid?(url)

        puts "The identifier was invalid."
        return
      end

      def scrape_embed_page(url)
        guesses = []
        embed_page = URI.parse(url).open
        xml_data = Nokogiri::HTML.parse(embed_page)
        name_field = xml_data.at_css(".company-name")
        guess = name_field.inner_text.gsub('at ', '').downcase.gsub(' ', '').strip if name_field
        guesses << guess unless guess.blank?
        homepage = xml_data.at_css("a")
        domain_string = homepage.attribute("href").value if homepage
        match = domain_string.match(%r{://[a-zA-Z]*\.?([^./]+)\.[a-z]{2,4}})
        guesses << match[1] if match
        return guesses
      end
    end
  end
end
