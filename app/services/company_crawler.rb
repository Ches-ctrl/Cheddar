class CompanyCrawler
  require 'open-uri'
  require 'nokogiri'
  require 'set'

  include Constants
  attr_reader :max_urls, :max_depth, :url_identifiers

  def initialize(max_urls:, max_depth:)
    @max_urls = max_urls
    @max_depth = max_depth
    @priority_stubs = CAREERS_STUBS
    @visited_urls = Set.new
    @priority_urls = Set.new  # URLs matching priority stubs
    @matched_urls = Set.new   # URLs matching identifiers
    @queue = Queue.new
    @lock = Mutex.new
    @terminate_flag = false   # Flag to signal termination
    @url_identifiers = ApplicantTrackingSystem.pluck(:url_identifier).flat_map { |identifiers| identifiers.split('|') }.sort
  end

  def crawl(url)
    p @url_identifiers

    @queue << [url, 0]

    threads = []
    max_threads = 3 # Define the maximum number of threads
    max_threads.times do
      threads << Thread.new do
        until @terminate_flag || @queue.empty? || @visited_urls.size >= max_urls
          current_url, depth = @queue.pop
          next if @visited_urls.include?(current_url)

          parse_and_enqueue(url, current_url, depth)
        end
      end
    end

    threads.each(&:join) # Wait for all threads to finish

    @matched_urls.to_a # Return the list of matched URLs
  end

  # Method to terminate all threads
  def stop_crawling
    @terminate_flag = true
  end

  private

  def parse_and_enqueue(base_url, url, depth)
    uri = URI.parse(url)
    uri = URI.join(base_url, uri) if uri.relative?
    p "URI: #{uri}"
    # uri = URI.parse("https://#{url}") if uri.is_a?(URI::Generic) && !uri.scheme
    doc = Nokogiri::HTML(uri.open)
    @visited_urls.add(url)

    return if depth >= max_depth || @terminate_flag # Check termination flag

    links = doc.css('a').map { |link| link['href'] }.compact
    priority_links, regular_links = classify_links(links)

    enqueue_urls(priority_links, depth)
    enqueue_urls(regular_links, depth + 1)
  rescue StandardError => e
    puts "Error parsing #{url}: #{e.message}"
  end

  def enqueue_urls(urls, depth)
    priority_urls = []
    regular_urls = []

    urls.each do |url|
      if contains_priority_stub?(url)
        priority_urls << [url, depth]
      else
        regular_urls << [url, depth]
      end
    end

    priority_urls.each { |url| @queue << url }
    regular_urls.each { |url| @queue << url }
  end

  def classify_links(links)
    priority_links = []
    regular_links = []

    links.each do |link|
      if contains_priority_stub?(link)
        priority_links << link
      elsif contains_identifier?(link)
        @matched_urls << link
      else
        regular_links << link
      end
    end

    [priority_links, regular_links]
  end

  def contains_priority_stub?(url)
    @priority_stubs.any? { |stub| url.include?(stub) }
  end

  def contains_identifier?(url)
    @url_identifiers.any? { |identifier| url.include?(identifier) }
  end
end
