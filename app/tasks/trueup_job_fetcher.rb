# frozen_string_literal: true

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
    # TODO: Create company separately, taking advantage of TrueUp company API

    url = @job_data['url']
    Url::CreateJobFromUrl.new(url).create_company_then_job
  end
end
