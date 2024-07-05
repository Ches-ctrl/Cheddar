# Helper for building the payload page with reference JSON outputs
module PayloadApplicationProcessesHelper
  def transformed_data(job_application)
    transformed_criteria = {}
    job_application.job.application_criteria.each do |attribute, criteria_hash|
      value = job_application.additional_info.fetch(criteria_hash['locators'], 'not_found')
      value = job_application.resume.url if attribute.eql?('resume') && job_application.resume.attached?
      value = job_application.cover_letter.url if attribute.include?('cover_letter') && job_application.cover_letter.attached?
      transformed_criteria[attribute] = criteria_hash.merge(value:)
    end
    transformed_criteria.to_json
  end

  def payload_title(job_app)
    "Payload for #{ats_name(job_app)}: #{company_name(job_app)} - #{job_title(job_app)}"
  end

  def posting_url(job_application)
    job_application.job.posting_url
  end

  private

  def ats_name(job_app)
    job_app.job.applicant_tracking_system.name
  end

  def company_name(job_app)
    job_app.job.company.name
  end

  def job_title(job_app)
    job_app.job.title
  end
end
