module PayloadApplicationProcessesHelper
  def transformed_data(job_application)
    translator = ApiFormatTranslators::BaseAtsTranslator.create_translator(job_application)
    if translator
      translator.translate
    else
      "#{job_application.job.applicant_tracking_system.name} translator not found!"
    end
  end

  def payload_title(job_application)
    ats_name = job_application.job.applicant_tracking_system.name
    company_name = job_application.job.company.name
    job_title = job_application.job.title
    "Payload for #{ats_name}: #{company_name} - #{job_title}"
  end
end
