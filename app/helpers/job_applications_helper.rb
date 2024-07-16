module JobApplicationsHelper
  def attachment_required_but_absent?(application_question_set, attachment)
    application_question_set.required && !attachment.attached?
  end

  def mandatory_field(application_question_set)
    application_question_set.required ? "* " : ""
  end

  def mandatory_fields_only_label(job_application)
    total = job_application.job.application_question_set.questions.count
    optionals = optional_fields(job_application.job.application_question_set).count
    "(#{optionals} out of #{total})"
  end

  def optional_fields(application_question_set)
    application_question_set.questions.reject(&:required)
  end

  def mandatory_fields_only_disability(job_application)
    'disabled' if optional_fields(job_application.job.application_question_set).none?
  end

  def mandatory_fields_only_disability_cursor_class(job_application)
    '!cursor-not-allowed ' if optional_fields(job_application.job.application_question_set).none?
  end
end
