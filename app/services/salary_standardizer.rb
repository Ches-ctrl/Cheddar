class SalaryStandardizer
  include ActiveSupport::NumberHelper

  CONVERTER = {
    '$' => ['$', ' USD'],
    '£' => ['£', ' GBP'],
    '€' => ['€', ' EUR'],
    'usd' => ['$', ' USD'],
    'can' => ['$', ' CAN'],
    'aud' => ['$', ' AUD'],
    'gbp' => ['£', ' GBP'],
    'eur' => ['€', ' EUR'],
  }

  def initialize(job)
    @job = job
  end

  def standardize
    return unless @job.job_description

    # salary_regex recognises five or six-figure numbers with comma separators that
    # either have a currency symbol or are followed by currency abbreviation e.g. GBP
    salary_regex = Regexp.new('([$£€] ?\d{2,3},\d{3}|\d{2,3},\d{3} ?(?:gbp|eur|usd|can|aud)|(?<=[$£€]\d{2},\d{3} - )\d{2,3},\d{3}|(?<=[$£€]\d{3},\d{3} - )\d{2,3},\d{3})', 'i')
    matches = @job.job_description.scan(salary_regex)
    equity = @job.job_description.match?(/\d{2,3},\d{3}.{0,28}equity/i)

    return if matches.empty?

    currency_match = matches.find do |expression|
      expression[0].match?(/(gbp|eur|usd|can|aud)/i)
    end&.first&.gsub(/[^a-z]/, '') || matches[0][0].match(/([£$€])/)[1]
    currency = currency_match ? CONVERTER[currency_match.downcase] : ['', '']

    salaries = matches.map { |expression| expression[0].gsub(/[^\d]/, '').to_i }

    salary_low = salaries.min
    salary_high = salaries.max

    if currency_match == '$'
      currency[1] = ' AUD' if @job.country == 'Australia'
      currency[1] = ' CAN' if @job.country == 'Canada'
    end

    @job.salary = number_to_currency(salary_low, unit: currency[0], precision: 0) +
                  (salary_high.positive? ? " - #{number_to_currency(salary_high, unit: currency[0], precision: 0)}" : "") +
                  currency[1] +
                  (equity ? " + equity" : "")
  end
end
