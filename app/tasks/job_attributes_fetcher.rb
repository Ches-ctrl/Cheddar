# frozen_string_literal: true

class JobAttributesFetcher < ApplicationTask
  def initialize(ats, company, job, data)
    @ats = ats
    @company = company
    @job = job
    @job_id = @job.ats_job_id
    @api_url = @ats.job_url_api(@ats.url_api, @company.ats_identifier, @job_id)
    @data = data || @ats.fetch_job_data(@job_id, @api_url, @company.ats_identifier)
  end

  def call
    return false unless processable

    process
  end

  private

  def processable
    return false if @data.blank? || @data['error'].present? || @data.values.include?(404)

    @ats && @company && @job
  end

  def process
    @job.assign_attributes(core_params)
    @job.assign_attributes(job_details)
    @job.build_application_question_set(
      form_structure: application_question_set
    )
    @job
  end

  def application_question_set
    @ats.respond_to?(:get_application_question_set) ? @ats.get_application_question_set(@job, @data) : []
  end

  def core_params
    {
      company: @company,
      applicant_tracking_system: @ats,
      api_url: @api_url
    }
  end

  def job_details
    @ats.job_details(@job, @data)
  end
end
