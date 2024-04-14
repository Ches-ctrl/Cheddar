class ScrapeMetaTags
  include AtsUrlIdentifiers
  include ValidUrl

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
    meta_tags = @doc.xpath('//meta[not(@property="og:description")]//@content')
    meta_tags.each do |tag|
      @external_links << tag.value if tag.value.match?(%r{https?://})
    end
  end

  def fetch_links_from_link_tags
    stylesheets = @doc.xpath('//link[@rel="stylesheet"]')
    stylesheets.each do |tag|
      @external_links << tag['href'] if tag['href']
    end
  end

  def fetch_links_from_scripts
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
    apply_link = apply_button&.attr('href')
    @external_links << apply_link if apply_link
  end

  def fetch_link_from_form
    form = @doc.xpath('//form')
    form_link = form&.attr('action')&.value
    p form_link if form_link
    @external_links << form_link if form_link
  end

  def fetch_ats_candidates_company_and_job
    candidates = []
    company = nil
    job_id = nil

    @external_links.each do |link|
      next unless (candidate = match_ats(link))

      begin
        ats, company, job = CreateJobByUrl.new(link).call
        if ats && company && !job
          job_id = ats.fetch_embedded_job_id(@url)
          job = ats.find_or_create_job_by_id(company, job_id) if job_id
          return [[candidate], company, job_id] if job
        end
      rescue NoMethodError => e
        missing_method = e.message.match(/`(.+?)'/)[1]
        p "Write a #{missing_method} method for #{candidate.name}!"
        # puts "Backtrace: #{e.backtrace.join("\n")}"
      end
      candidates << candidate
    end
    candidates.uniq!
    company = job_id = nil if candidates.size > 1
    [candidates, company, job_id]
  end

  def apply_button
    @doc.xpath('//a | //button').detect { |node| node.text.match?(/apply/i) }
  end
end
