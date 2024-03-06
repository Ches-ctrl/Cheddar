class SalaryStandardizer
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
    # either have a currency symbol or are followed by three-letter sequence e.g. GBP
    salary_regex = Regexp.new('([$£€]\d{2,3},\d{3}(?: \b[a-z]{3}\b)?|[$£€]?\d{2,3},\d{3}(?: \b[a-z]{3}\b))(?=.{0,28}(equity))?','i')
    matches = @job.job_description.scan(salary_regex)

    unless matches.empty?
      range = [matches.min_by { |salary, _equity| salary.gsub(/[^\d]/, '').to_i }, matches.max_by { |salary, _equity| salary.gsub(/[^\d]/, '').to_i }]

      salary_low = range[0][0].gsub(/[^\d,]/, '')
      salary_high = range[1][0].gsub(/[^\d,]/, '')
      currency_match = range[1][0].match(/(?:\d{3} )\b(gbp|usd|eur|can|aud)\b?/i) || range[1][0].match(/([£$€])/)
      currency = currency_match ? CONVERTER[currency_match[1].downcase] : ['', '']

      p currency_match
      p currency

      if currency_match[1] == '$'
        currency[1] = ' AUD' if @job.country == 'Australia'
        currency[1] = ' CAN' if @job.country == 'Canada'
      end

      salary = "#{currency[0]}#{(salary_low)} - #{currency[0]}#{(salary_high)}#{currency[1]}"
      salary += " + equity" if range[0][1] || range[1][1]
      @job.salary = salary
    end
  end
end
