# frozen_string_literal: true
# ats.find_or_create_job(company, job_id)
# ats.find_or_create_job_by_data(company, @job_data)
class JobCreator < ApplicationTask
  def initialize(params)
    @ats = params[:ats]
    @company = params[:company]
    @data = params[:data]
    @job_id = params[:job_id] || @ats.fetch_id(@data)
  end

  def call
    return unless processable

    process
  rescue StandardError => e
    Rails.logger.error "Error creating job: #{e.message}"
  end

  private

  def processable
    @ats && @company && @job_id
  end

  def process
    create_job
    log_and_save_new_company
    update_apply_with_cheddar
  end

  def create_company
    @job = Job.find_or_initialize_by(ats_job_id: @job_id) do |new_job|
      new_job.assign_attributes(job_params)
    end
  end

  def job_params
    @data ||= @ats.fetch_job_data(new_job)

    params = @ats.job_details(@ats_identifier)
    params.merge(supplementary_attributes_from_data)
          .merge(
            company: @company,
            applicant_tracking_system: @ats
          )
  end

  def log_and_save_new_company
    Rails.logger.info "Company created - #{@company.name}" if @company.new_record? && @company.save
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
