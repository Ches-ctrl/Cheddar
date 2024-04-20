class ScrapeMetaTags
  include AtsUrlIdentifiers
  include CheckUrlIsValid

  # TODO: Figure out where exactly this class should be called

  def initialize(url)
    @url = url
    @external_links = []
  end

  def call
    return unless url_valid?(@url) # raise Invalid Url Error?

    p "Grabbing meta information for #{@url}"

    fetch_doc
    fetch_links_from_meta_tags
    fetch_links_from_link_tags
    fetch_links_from_scripts
    fetch_link_from_apply_button
    fetch_link_from_form
    fetch_ats_candidates_company_and_job
  end

  private

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

  def fetch_link_from_form
    puts "Fetching links from forms..."
    form = @doc.xpath('//form')
    form_link = form&.attr('action')&.value
    @external_links << form_link if form_link
  end

  def fetch_ats_candidates_company_and_job
    puts "Processing links..."
    @candidates = []

    @external_links.each do |link|
      next unless (candidate = match_ats(link))

      ats, company, job = CreateJobFromUrl.new(link).create_company_then_job
      return if job&.persisted? # presumably job will be persisted even if not live? this might need tweaking with non-live jobs

      # TODO: Consider moving this logic to ApplicantTrackingSystem:
      if ats && company && !job
        job_id = ats.fetch_embedded_job_id(@url)
        job = ats.find_or_create_job(company, job_id) if job_id
        return if job&.persisted?

        puts "Associated #{link} from #{@url} meta tags with #{ats.name} and #{company.company_name} but couldn't create job."
        puts "Adding ats_identifier #{company.ats_identifier} to ats_identifiers csv"
        return [ats, company]
      end

      @candidates << candidate
    end
    return if @candidates.empty?

    @candidates.uniq!
    best_candidate = @candidates.size > 1 ? pick_best_candidate : @candidates.first

    [best_candidate]
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
