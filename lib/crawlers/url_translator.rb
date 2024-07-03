module Crawlers
  # Class for doing url substitutions when an ats' job url format and job board url format differ.
  #
  # i.e. `smartrecruiters` is
  # `https://jobs.smartcruiters.com/company_id/job_id`
  # and
  # `https://careers.smartrecruiters.com/company_id`
  #
  # NOTE: This class doesn't remove `job_id` in the above example, just swaps `jobs` with `careers`
  class UrlTranslator
    # `ats_id` should be a string that can be used to identify a url as belonging
    # to the ats this translator is for.
    #
    # `translations` should be a `Hash` containing key-value pairs representing
    # the job url chunk to be replaced and its board url chunk replacement.
    # i.e. `{'jobs' => 'careers'}`
    #
    # @param ats_id [String]
    #
    # @param translations [Hash<String, String>]
    def initialize(ats_id, translations)
      @ats_id = ats_id
      @translations = translations
    end

    # Checks if `url` belongs to this `ats` and can then be translated.
    #
    # @param url [String]
    #
    # @return [TrueClass, FalseClass]
    def translate?(url)
      return url.include?(@ats_id)
    end

    # Performs translations and returns the translated url.
    #
    # @param url [String]
    #
    # @return [String]
    def translate(url)
      if translate?(url)
        @translations.each do |job, board|
          # May need to make this more sophisticated at some point
          # i.e. in cases like swapping 'jobs' and 'careers',
          # those substrings may be in the company id and shouldn't be replaced
          # but the company could come first so may need to use `sub` on the string in reverse.
          url = url.sub(job, board)
        end
      end
      return url
    end
  end
end
