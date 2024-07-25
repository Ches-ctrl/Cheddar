# frozen_string_literal: true

class SubsequentJobApplicationsResumeAttacher < ApplicationTask
  def initialize(application_process, job_application)
    @application_process = application_process
    @resume = job_application.resume
    @subsequent_job_applications = application_process.job_applications
                                                      .where(id: job_application.id..)
                                                      .where.not(id: job_application.id)
  end

  def call
    # true because optional task
    return true unless processable

    process
  end

  private

  def processable
    @resume.attached? && @subsequent_job_applications.any?
  end

  def process
    attach_resume
  end

  ###

  def attach_resume
    @subsequent_job_applications.map { |job_application| job_application.resume.attach(@resume.blob) }
  end
end
