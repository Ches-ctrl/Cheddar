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

    application_criteria # TODO: rewrite modules so this returns an attribute hash like job_details
    @job.save
  end

  def application_criteria
    @ats.get_application_criteria(@job, @data)
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
