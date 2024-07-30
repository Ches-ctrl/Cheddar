# frozen_string_literal: true

class CompanyCreator < ApplicationTask
  def initialize(params)
    @ats = params[:ats]
    @data = params[:data]
    @ats_identifier = params[:ats_identifier] || @ats.fetch_company_id(@data)
    @apply_with_cheddar = params[:apply_with_cheddar]
  end

  def call
    return unless processable

    process
  rescue StandardError => e
    Rails.logger.error "Error creating company: #{e.message}"
    nil
  end

  private

  def processable
    @ats && @ats_identifier
  end

  def process
    create_company
    log_and_save_new_company
    update_apply_with_cheddar
  end

  def create_company
    @company = Company.find_or_initialize_by(ats_identifier: @ats_identifier) do |new_company|
      new_company.assign_attributes(company_params)
    end
  end

  def company_params
    params = @ats.company_details(@ats_identifier)
    params.merge(supplementary_attributes_from_data)
          .merge(applicant_tracking_system: @ats)
  end

  def log_and_save_new_company
    return unless @company&.new_record?

    p CompanyDescriptionFetcher.call(@company)
    p @company.set_website_url
    Rails.logger.info "Company created - #{@company.name}" if @company.save
  end

  def supplementary_attributes_from_data
    return {} unless @data

    @ats.company_details_from_data(@data)
  end

  def update_apply_with_cheddar
    @company.update(apply_with_cheddar: @apply_with_cheddar) if @apply_with_cheddar
    @company
  end
end
