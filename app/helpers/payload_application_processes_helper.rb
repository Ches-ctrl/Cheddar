# Helper for building the payload page with reference JSON outputs
module PayloadApplicationProcessesHelper
  def transformed_data(job_application)
    job_application.api_payload
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

  def payload_data(job_application)
    questions = job_application.application_question_set.questions
    questions.map do |question|
      {
        question.attribute => {
          'selector' => question.selector,
          'type' => question.type,
          'value' => question.answered_value(job_application).to_s
        }
      }
    end
  end
end
