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
  end

  private

  def processable
    @ats && @ats_identifier
  end

  def process
    create_company
    assign_attributes_from_supplementary_data
    log_and_save_new_company
    update_apply_with_cheddar
  end

  def assign_attributes_from_supplementary_data
    return unless @data

    p "Supplementary data found"
    supplementary_data = @ats.company_details_from_data(@data)
    @company.assign_attributes(supplementary_data)
  end

  def create_company
    @company = Company.find_or_initialize_by(ats_identifier: @ats_identifier) do |new_company|
      new_company.assign_attributes(company_params)
    end
  end

  def company_params
    params = @ats.company_details(@ats_identifier)
    params.merge(applicant_tracking_system: @ats)
  end

  def log_and_save_new_company
    Rails.logger.info "Company created - #{@company.name}" if @company.new_record? && @company.save
  end

  def update_apply_with_cheddar
    @company.update(apply_with_cheddar: @apply_with_cheddar) if @apply_with_cheddar
    @company
  end
end
