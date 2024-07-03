require 'csv'

module Crawlers
  class BoardExtractor
    def initialize
      @company_id_regex = '[a-zA-Z0-9\-\_]+'
      @version_regex = '[0-9]+'
      @uuid_regex = '[a-zA-Z0-9\-]+'
      @workday_stub_regex = '([a-zA-Z\-]+/)?[a-zA-Z0-9\-\_]+'
      @pattern_pairs = ['${company_id}', @company_id_regex],
                       ['${version}', @version_regex],
                       ['${uuid}', @uuid_regex],
                       ['${workday_stub}', @workday_stub_regex]
      @prematch_translators = [UrlTranslator.new('smartrecruiters', { 'jobs' => 'careers' }),
                               UrlTranslator.new('paycomonline', { %r{/ViewJobDetails\?job=[0-9]+&} => '?' })]
      @postmatch_translators = [UrlTranslator.new('myworkdayjobs', { '/job' => '' })]
      load_template_urls
      build_patterns
    end

    private

    # Load board template urls from `storage/csv/ats_systems.csv`
    def load_template_urls
      @template_urls = []
      ats_csv = CSV.parse(File.read(File.join(Rails.root, 'storage/csv/ats_systems.csv')), headers: true)
      ats_csv.each do |row|
        next if row['board_template_url'].nil?

        @template_urls.append(row['board_template_url'])
      end
    end

    # Build template url patterns from placeholder strings
    def build_patterns
      @template_urls.map! do |url|
        @pattern_pairs.each do |placeholder, regex|
          url = url.gsub(placeholder, regex)
        end
        Regexp.new("(#{url})")
      end
    end

    # Perform any applicable translations using the provided `UrlTranslator` list.
    #
    # @param url [String]
    #
    # @param translators [Array<UrlTranslator>]
    #
    # @returns [String]
    def translate(url, translators)
      translators.each do |translator|
        if translator.translate?(url)
          url = translator.translate(url)
          return url
        end
      end
      return url
    end

    public

    # Given a url, extract and return the base url for the job board, if present.
    #
    # If a match can't be found, `nil` will be returned.
    #
    # @param url [String]
    #
    # @return [String, NilClass]
    def extract(url)
      url = translate(url, @prematch_translators)
      @template_urls.each do |template|
        match = url.match(template)
        return translate(match[0], @postmatch_translators) unless match.nil?
      end
      return nil
    end
  end
end
