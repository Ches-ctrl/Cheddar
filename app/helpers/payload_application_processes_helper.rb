module PayloadApplicationProcessesHelper
  def transformed_data(job_application)
    # translator = ApiFormatTranslators::BaseAtsTranslator.create_translator(job_application)
    # if translator
    #   translator.translate
    # else
    #   "#{job_application.job.applicant_tracking_system.name} translator not found!"
    # end

    transformed_criteria = {}
    job_application.job.application_criteria.each do |attribute, criteria_hash|
      value = job_application.additional_info.fetch(criteria_hash['locators'], 'not_found')
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
