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
          %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/(?!embed)([^/]+)(?:/jobs/(\d+))?},
          %r{https://boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?for=([^&]+)(?:&token=(\d+))?},
          %r{https://boards-api\.?[a-zA-Z]*\.greenhouse\.io(?:/v1/boards)?/([^/]+)(?:/jobs/(\d+))?}
        ]

        alt_formats = [
          %r{://(?:[^.]+\.)?([^./]+)\.[a-z]{2,4}[./](?:.*gh_jid=(\d+))?}
        ]

        embedded_formats = [
          %r{://boards\.?[a-zA-Z]*\.greenhouse\.io/embed/job_app\?token=(\d+)}
        ]

        ats_identifier, job_id = try_standard_formats(url, regex_formats)
        return [ats_identifier, job_id] if ats_identifier

        alt_formats.each do |regex|
          next unless (match = url.match(regex))

          ats_identifier, job_id = match.captures
          return [ats_identifier, job_id] if confirm(ats_identifier, saved_ids)
        end

        return nil unless valid?(url)

        embedded_formats.each do |regex|
          next unless (match = url.match(regex))

          job_id = match[1]
          scrape_embed_page(url).each do |ats_identifier|
            return [ats_identifier, job_id] if confirm(ats_identifier, saved_ids)
          end
        end
        return nil
      end

      private

      private_class_method def self.confirm(potential_identifier, saved_ids)
        # TODO: In production, Company.all and not ats_list will be single source of truth.
        saved_ids ||= ats_list[this_ats.name]
        return true if saved_ids.include?(potential_identifier)

        puts "\nTesting the ats_identifier: #{potential_identifier}"
        url = "#{base_url_api}#{potential_identifier}/"
        return potential_identifier if valid?(url)

        puts "the identifier was invalid."
        return
      end

      private_class_method def self.scrape_embed_page(url)
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
