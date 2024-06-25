class CompanyCreator
  def initialize(params)
    @ats = params[:ats]
    @ats_identifier = params[:ats_identifier]
    @data = params[:data]
    @apply_with_cheddar = params[:apply_with_cheddar]
  end

  def call
    return unless processable

    process
  end

  def processable
    @ats && (@ats_identifier || @data)
  end

  def process
    fetch_ats_identifier unless @ats_identifier
    find_or_create_company
  end

  private

  def fetch_ats_identifier
    @ats_identifier = @ats.fetch_company_id(@data)
  end

  def find_or_create_company
    p "Finding or creating company with ATS identifier #{@ats_identifier}"
    return unless @ats_identifier.present?

    create_company
    assign_attributes_from_supplementary_data if @data
    log_and_save_new_company
    update_apply_with_cheddar
    return @company
  end

  def assign_attributes_from_supplementary_data
    p "Supplementary data found"
    supplementary_data = @ats.company_details_from_data(@data)
    @company.assign_attributes(supplementary_data)
  end

  def create_company
    @company = Company.find_or_initialize_by(ats_identifier: @ats_identifier) do |new_company|
      company_data = @ats.company_details(@ats_identifier)

      new_company.applicant_tracking_system = @ats
      new_company.assign_attributes(company_data)
    end
  end

  def log_and_save_new_company
    Rails.logger.info "Company created - #{@company.name}" if @company.new_record? && @company.save
  end

  def update_apply_with_cheddar
    @company.update(apply_with_cheddar: @apply_with_cheddar) if @apply_with_cheddar
  end
end
