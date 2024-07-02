module Scraper
  # Class for creating custom user agents
  class UserAgent
    require 'json'
    require 'open-uri'
    require 'nokogiri'

    # TODO: Fix this later as doesn't quite work properly. Do we want them to be class or instance methods? At the moment creates multiple versions of browserVersions.json

    # Example 1: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36
    # Example 2: Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.2111.38 Safari/537.36 Vivaldi/5.1.1510.6
    # Example 3: Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.2840.6 Safari/537.36 OPR/109.0.4799.25
    # Example 4: Mozilla/5.0 (x11; Ubuntu; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.2276.41 Safari/537.36 OPR/108.0.2532.33
    # Example 5: Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.61.45 Safari/537.36

    attr_accessor :firefox, :chrome, :safari, :edge, :vivaldi, :opera

    def initialize
      @versions_path = File.expand_path(File.join(__dir__, 'browserVersions.json'))
      @firefox = ''
      @chrome = ''
      @safari = ''
      @edge = ''
      @vivaldi = ''
      @opera = ''
      create_versions_file unless File.exist?(@versions_path)
    end

    # == Class Methods ========================================================
    def self.randomize_version_number(version)
      parts = version.split('.').map(&:to_i)
      parts[0] = rand(parts[0] - 1..parts[0])
      parts[1..-1] = parts[1..].map { |part| rand(0..part) }
      parts.join('.')
    end

    # == Instance Methods =====================================================
    def update_firefox
      url = URI.parse('https://www.mozilla.org/en-US/firefox/releases/')
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        version = doc.css('ol.c-release-list ol li a').first.text
        @firefox = version
      else
        puts "Error updating Firefox: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "Error updating Firefox: #{e.message}"
    end

    def update_chrome
      url = URI.parse('https://en.wikipedia.org/wiki/Google_Chrome')
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        raw = doc.css('td.infobox-data')[7].text
        version = raw.slice(0...[raw.index('['), raw.index('/')].min)
        @chrome = version
      else
        puts "Error updating Chrome: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "Error updating Chrome: #{e.message}"
    end

    def update_safari
      url = URI.parse('https://en.wikipedia.org/wiki/Safari_(web_browser)')
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        version = doc.css('td.infobox-data')[2].text.slice(0...doc.css('td.infobox-data')[2].text.index('['))
        @safari = version
      else
        puts "Error updating Safari: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "Error updating Safari: #{e.message}"
    end

    def update_edge
      url = URI.parse('https://www.techspot.com/downloads/7158-microsoft-edge.html')
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        version = doc.css('div.subver').text
        @edge = version
      else
        puts "Error updating Edge: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "Error updating Edge: #{e.message}"
    end

    def update_vivaldi
      url = URI.parse('https://vivaldi.com/blog/')
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        text = doc.css('div.download-vivaldi-sidebar').text
        text = text.split(' - ')[1]
        text = text.gsub(' (', '.')
        version = text.slice(0...text.index(')'))
        @vivaldi = version
      else
        puts "Error updating Vivaldi: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "Error updating Vivaldi: #{e.message}"
    end

    def update_opera
      url = URI.parse('https://en.wikipedia.org/wiki/Opera_(web_browser)')
      response = Net::HTTP.get_response(url)
      if response.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(response.body)
        version = doc.css('td.infobox-data')[2].css('div').first.text.slice(0...doc.css('td.infobox-data')[2].css('div').first.text.index('['))
        @opera = version
      else
        puts "Error updating Opera: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "Error updating Opera: #{e.message}"
    end

    def update_all
      threads = %i[update_firefox update_chrome update_safari update_edge update_vivaldi update_opera].map do |method_name|
        Thread.new { send(method_name) }
      end
      threads.each(&:join)

      versions = {
        Firefox: @firefox,
        Chrome: @chrome,
        Edg: @edge,
        Vivaldi: @vivaldi,
        OPR: @opera,
        Safari: @safari
      }
      versions.delete_if { |_, v| v.empty? || v.gsub('.', '').match?(/\D/) }

      previous_versions = JSON.parse(File.read(@versions_path))
      versions.merge!(previous_versions)

      File.write(@versions_path, JSON.pretty_generate(versions))
    end

    def create_versions_file
      File.write(@versions_path, JSON.pretty_generate({}))
    end

    def create_agent
      platforms = [
        '(Windows NT 10.0; Win64; x64)',
        '(x11; Ubuntu; Linux x86_64)',
        '(Windows NT 11.0; Win64; x64)',
        '(Macintosh; Intel Mac OS X 13_0_0)'
      ]
      browsers = JSON.parse(File.read(File.join(__dir__, 'browserVersions.json')))
      browsers.transform_values! { |v| randomize_version_number(v) }
      browser = browsers.keys.sample
      if browser == 'Safari'
        platform = platforms[-1]
        "Mozilla/5.0 #{platform} AppleWebKit/605.1.15 (KHTML, like Gecko) Version/#{browsers['Safari']} Safari/605.1.15"
      else
        platform = platforms.sample
        if browser == 'Firefox'
          platform = platform[0...platform.rindex(')')] + "; rv:#{browsers[browser]})"
          "Mozilla/5.0 #{platform} Gecko/20100101 Firefox/#{browsers[browser]}"
        else
          useragent = "Mozilla/5.0 #{platform} AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{browsers['Chrome']} Safari/537.36"
          useragent += " Edg/#{browsers['Edg']}" if browser == 'Edg'
          useragent += " OPR/#{browsers['OPR']}" if browser == 'OPR'
          useragent += " Vivaldi/#{browsers['Vivaldi']}" if browser == 'Vivaldi'
          useragent
        end
      end
    end

    def create_header
      { 'User-Agent' => create_agent }
    end
  end
end
