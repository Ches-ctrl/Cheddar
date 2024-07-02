# Helper for building the payload page with reference JSON outputs
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
