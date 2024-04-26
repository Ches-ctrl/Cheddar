module Standardizer
  class SalaryStandardizer
    include ActiveSupport::NumberHelper
    include Constants

    def initialize(job)
      @job = job
    end

    def standardize
      return unless (search_field = @job.salary || @job.job_description)

      # salary_regex recognises five or six-figure numbers with comma separators that
      # either have a currency symbol or are followed by currency abbreviation e.g. GBP
      salary_regex = Regexp.new(
        '([$£€] ?\d{2,3},\d{3}|\d{2,3},\d{3}(?= ?- ?\d{2,3},\d{3} ?(?:gbp|eur|usd|can|aud))|\d{2,3},\d{3} ?(?:gbp|eur|usd|can|aud)|(?<=[$£€]\d{2},\d{3} - )\d{2,3},\d{3}|(?<=[$£€]\d{3},\d{3} - )\d{2,3},\d{3})', 'i'
      )
      matches = search_field.scan(salary_regex)
      equity = @job.job_description&.match?(/\d{2,3},\d{3}.{0,28}equity/i)

      return if matches.empty?

      currency_match = matches.find do |expression|
        expression[0].match?(/(gbp|eur|usd|can|cdn|cad|aud)/i)
      end&.first&.downcase&.gsub(/[^a-z]/, '') || matches[0][0].match(/([£$€])/)[1]
      currency = currency_match.blank? ? ['', ''] : CURRENCY_CONVERTER[currency_match]

      salaries = matches.map { |expression| expression[0].gsub(/[^\d]/, '').to_i }

      salary_low = salaries.min
      salary_high = salaries.max if salaries.size > 1

      if currency_match == '$' && !@job.countries.empty?
        currency[1] = ' AUD' if @job.countries.first.name == 'Australia'
        currency[1] = ' CAD' if @job.countries.first.name == 'Canada'
      end

      @job.salary = number_to_currency(salary_low, unit: currency[0], precision: 0) +
                    (if salary_high
                       " - #{number_to_currency(salary_high, unit: currency[0],
                                                             precision: 0)}"
                     else
                       ""
                     end) +
                    currency[1] +
                    (equity ? " + equity" : "")
    end
  end
end
