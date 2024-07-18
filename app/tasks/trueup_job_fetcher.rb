# frozen_string_literal: true

# TODO: process_as_true_up_job if unable to create_job_from_url
class TrueupJobFetcher < ApplicationTask
  def initialize(job_data)
    @job_data = job_data
  end

  def call
    return unless processable

    process
  end

  def processable
    true
  end

  def process
    # TODO: Create company separately, taking advantage of TrueUp company API?

    url = @job_data['url']
    _ats, _company, job = Url::CreateJobFromUrl.new(url).create_company_then_job
    process_as_true_up_job unless job&.persisted?
  end

  private

  def process_as_true_up_job
    ats = ApplicantTrackingSystem.find_by(name: 'TrueUp')
    company = CompanyCreator.call(ats:, data: @job_data, apply_with_cheddar: false)
    p "Company: #{company&.name}"

    job = JobCreator.call(ats:, company:, data: @job_data)
    p "Job: #{job&.title}"
  end
end
