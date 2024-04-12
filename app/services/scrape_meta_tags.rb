class ScrapeMetaTags
  include Constants

  def initialize(url)
    @url = url
    @external_links = []
  end

  def call
    p "Grabbing the meta tags for #{@url}"

    fetch_links_from_meta_tags
    fetch_ats

    p "I've determined this job is associated with #{@ats.name}" if @ats
    p "Finished."
    @ats
  end

  private

  def fetch_links_from_meta_tags
    html = URI.parse(@url).open
    xml = Nokogiri::HTML.parse(html)
    meta_tags = xml.xpath('//head//meta//@content')
    meta_tags.each do |tag|
      @external_links << tag.value if tag.value.match?(%r{https?://})
    end
  end

  def fetch_ats
    @external_links.each do |link|
      ATS_SYSTEM_PARSER.each do |regex, ats_name|
        return @ats = ApplicantTrackingSystem.find_by(name: ats_name) if link.match?(regex)
      end
    end
    @ats = nil
  end
end
