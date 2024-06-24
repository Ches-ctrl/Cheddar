class CompanyDescriptionFetcher
  def initialize(company)
    @company = company
  end

  def call
    return false unless processable

    process
  end

  def processable
    @company.name.present? || @company.url_website.present?
  end

  def process
    return fetch_and_assign_details_from_url if @company.url_website.present?
    return fetch_and_assign_description_from_name if Rails.env.production?

    @company.description ||= 'A financial services company.'
  end

  private

  def fetch_and_assign_details_from_url
    details = Categorizer::CompanyDetailsFromUrl.new(@company.url_website).call
    @company.name = details[:name] if details[:name].present?
    @company.description = details[:description] if @company.description.blank?
    @company.url_linkedin ||= details[:url_linkedin]
    @company.url_website = details[:url_website] if details[:url_website]
    @company.save
  end

  def fetch_and_assign_description_from_name
    return unless @company.description.blank?

    inferred_description, @name_keywords = Categorizer::CompanyDescriptionService.lookup_company(@company.name, @company.ats_identifier)
    @company.description = inferred_description
  end
end
