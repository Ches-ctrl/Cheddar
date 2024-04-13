class ScrapeMetaTags
  include AtsUrlIdentifiers
  include ValidUrl

  def initialize(url)
    @url = url
    @external_links = []
  end

  def call
    return false unless url_valid?(@url)

    p "Grabbing meta information for #{@url}"

    fetch_doc
    fetch_links_from_meta_tags
    fetch_links_from_scripts
    fetch_link_from_apply_button
    fetch_ats_candidates

    if @candidates.size == 1
      ats = @candidates.first
      p "I've determined this job is associated with #{ats.name}"
    elsif @candidates.size > 1
      p "Here are the ATS candidates:"
      @candidates.each { |ats| p "  #{ats.name}"}
    end
    p "Finished."
    @ats
  end

  private

  def fetch_doc
    html = URI.parse(@url).open
    @doc = Nokogiri::HTML.parse(html)
  end

  def fetch_links_from_meta_tags
    meta_tags = @doc.xpath('//head//meta//@content')
    meta_tags.each do |tag|
      @external_links << tag.value if tag.value.match?(%r{https?://})
    end
  end

  def fetch_links_from_scripts
    script_tags = @doc.xpath('//script')
    script_tags.each do |tag|
      matches = tag.content.scan(%r{"(https?://.+)"}).flatten
      matches.each do |match|
        @external_links << match
      end
    end
  end

  def fetch_link_from_apply_button
    apply_link = apply_button.attr('href')
    @external_links << apply_link if apply_link
  end

  def fetch_ats_candidates
    @candidates = []
    @external_links.each do |link|
      p link
      candidate = match_ats(link)
      @candidates << candidate if candidate
    end
  end

  def apply_button
    @doc.xpath('//a | //button').detect { |node| node.text.match?(/apply/i) }
  end
end
