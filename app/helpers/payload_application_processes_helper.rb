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

  def payload_title(job_application)
    ats_name = job_application.job.applicant_tracking_system.name
    company_name = job_application.job.company.name
    job_title = job_application.job.title
    "Payload for #{ats_name}: #{company_name} - #{job_title}"
  end
end
