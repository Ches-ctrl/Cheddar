# frozen_string_literal: true

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
    nil
  end

  private

  def processable
    @ats && @company && @job_id
  end

  def process
    create_job
    log_and_save_new_job
  end

  def create_job
    @job = Job.find_or_initialize_by(ats_job_id: @job_id) do |new_job|
      JobAttributesFetcher.call(@ats, @company, new_job, @data)
    end
  end

  def log_and_save_new_job
    Rails.logger.info "Job created - #{@job.title}" if @job.new_record? && @job.save
    @job
  end
end
