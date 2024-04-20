class CompanyIndustryService
  # TODO: Let's discuss this in a little more detail (CC/DS)

  def self.lookup_industry(company_name, keywords)
    results = api_lookup(company_name)
    p results

    # @company_words = company_name.split(/(?<=[a-z])(?=[A-Z])| /)
    @company_words = keywords.map(&:downcase)
    candidates = []
    results['items'].each do |result|
      next if result['company_type'] == 'oversea-company'

      matching_words, number_of_words = compare(result['company_name'])
      candidates << [matching_words, number_of_words, result['sic_codes'] || []]
    end
    p candidates
    sic_codes = candidates.min_by { |a, b| [-a, b] }[2]
    fetch_industry(sic_codes)
  rescue => e
    p e.message
    Rails.logger.error("Error fetching company info from Companies House: #{e.message}")
  end

  def self.compare(candidate)
    candidate_words = candidate.downcase.split
    matching_words = candidate_words.count { |word| @company_words.include?(word) }
    [matching_words, candidate_words.length]
  end

  def self.fetch_industry(sic_codes)
    p all_industry_categories = sic_codes.map(&:to_i)
    # TODO: allow a company to have more than one industry category
    first_industry_category = all_industry_categories.first
    first_industry_subcategory = nil
    [first_industry_category, first_industry_subcategory]
  end

  private

  private_class_method def self.api_lookup(company_name)
    base_url = 'https://api.company-information.service.gov.uk/'
    resource_path = "advanced-search/companies?company_name_includes=#{URI.encode_www_form_component(company_name&.downcase)}&company_status=active&size=20"

    response = HTTParty.get(
      "#{base_url}#{resource_path}",
      basic_auth: { username: ENV.fetch('COMPANIES_HOUSE_API_KEY') }
    )

    JSON.parse(response.body)
  end
end
