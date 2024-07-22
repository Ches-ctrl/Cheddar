module Importer
  class ScrapeMetaTags
    include AtsUrlIdentifiers
    include CheckUrlIsValid

    # TODO: Figure out where exactly this class should be called
    # TODO: Simplify this down

    def initialize(url)
      @url = url
      @external_links = []
      @doc = nil
    end

    def call
      return unless able_to_fetch_document? # raise Invalid Url Error?

      p "Grabbing meta information for #{@url}"

      fetch_links_from_meta_tags
      fetch_links_from_link_tags
      fetch_links_from_scripts
      fetch_links_from_iframes
      fetch_links_from_anchor_tags
      fetch_link_from_apply_button
      fetch_link_from_forms
      fetch_ats_candidates_company_and_job
    end

    private

    def able_to_fetch_document?
      # TODO: refactor this to use Faraday

      Timeout.timeout(5) do
        loop do
          puts "trying to get a response: #{@url}"
          response = get_response(@url)
          case response
          when Net::HTTPSuccess
            return fetch_doc
          when Net::HTTPRedirection || Net::HTTPMovedPermanently
            @url = fetch_redirect(@url, response)
          else
            p response
            return false
          end
        end
      end
    rescue Timeout::Error
      p "Timeout while fetching document from #{@url}"
      return false
    end

    def fetch_doc
      html = URI.parse(@url).open
      @doc = Nokogiri::HTML.parse(html)
    end

    def fetch_links_from_meta_tags
      puts "Fetching links from meta tags..."
      meta_tags = @doc.xpath('//meta[not(@property="og:description")]//@content')
      meta_tags.each do |tag|
        @external_links << tag.value if tag.value.match?(%r{https?://})
      end
    end

    def fetch_links_from_iframes
      puts "Fetching links from iframes..."
      @external_links += @doc.xpath('//iframe/@src').map(&:to_s)
    end

    def fetch_links_from_anchor_tags
      puts "Fetching links from anchor tags..."
      @external_links += @doc.xpath('//a/@href').map(&:to_s)
    end

    def fetch_links_from_link_tags
      puts "Fetching links from stylesheets..."
      stylesheets = @doc.xpath('//link[@rel="stylesheet"]')
      stylesheets.each do |tag|
        @external_links << tag['href'] if tag['href']
      end
    end

    def fetch_links_from_scripts
      puts "Fetching links from scripts..."
      script_tags = @doc.xpath('//script')
      script_tags.each do |tag|
        matches = tag.content.scan(%r{[",](https?://.+?)[",]}).flatten
        matches << tag['src'] if tag['src']&.match?(%r{https?://})
        matches.each do |match|
          @external_links << match
        end
      end
    end

    def fetch_link_from_apply_button
      puts "Fetching links from apply button..."
      apply_link = apply_button&.attr('href')
      @external_links << apply_link if apply_link
    end

    def fetch_link_from_forms
      puts "Fetching links from forms..."
      forms = @doc.xpath('//form')
      forms.each do |form|
        form_link = form.attr('action')
        @external_links << form_link if form_link
      end
    end

    def fetch_ats_candidates_company_and_job
      puts "Processing links..."
      @candidates = []

      @external_links.each do |link|
        next unless (candidate = match_ats(link))

        p "Found a promising link: #{link}..."
        ats, company, job = Url::CreateJobFromUrl.new(link).create_company_then_job
        return if job&.persisted? # presumably job will be persisted even if not live? this might need tweaking with non-live jobs

        # TODO: Consider moving this logic to ApplicantTrackingSystem:
        if ats && company && !job
          job_id = ats.fetch_embedded_job_id(@url)
          job = JobCreator.call(ats:, company:, job_id:) if job_id
          return if job&.persisted?

          puts "Associated #{link} from #{@url} meta tags with #{ats.name} and #{company.name} but couldn't create job."
          puts "Adding ats_identifier #{company.ats_identifier} to ats_identifiers csv"
          return [ats, company]
        end

        @candidates << candidate
      end
      return check_for_grnhse_app if @candidates.empty?

      @candidates.uniq!
      best_candidate = @candidates.size > 1 ? pick_best_candidate : @candidates.first

      [best_candidate]
    end

    def check_for_grnhse_app
      grnhse_app_div = @doc.at('div#grnhse_app')
      gh_job_post_id_input = @doc.at('input#ghJobPostId')
      return [ApplicantTrackingSystem.find_by(name: 'Greenhouse')] if grnhse_app_div || gh_job_post_id_input
    end

    def apply_button
      @doc.xpath('//a | //button').detect { |node| node.text.match?(/apply/i) }
    end

    def pick_best_candidate
      # TODO: make this method smarter!
      reject_job_boards
      prefer_taleo_to_select_minds
      @candidates = @candidates.first
    end

    def reject_job_boards
      reject_list = [
        'LinkedIn',
        'Otta',
        'TotalJobs'
      ]
      @candidates.reject! { |candidate| reject_list.include?(candidate.name) }
    end

    def prefer_taleo_to_select_minds
      @candidates.reject! { |candidate| candidate.name == 'SelectMinds' } if @candidates.map(&:name).include?('Taleo')
    end
  end
end
