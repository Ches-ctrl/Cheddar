module JobApplicationsHelper
  def attachment_required_but_absent?(application_criteria, attachment)
    application_criteria.required && !attachment.attached?
  end

  def mandatory_field(application_criteria)
    application_criteria.required ? "* " : ""
  end

  def mandatory_fields_only_label(job_application)
    total = job_application.job.application_criterion.questions.count
    optionals = optional_fields(job_application.job.application_criterion).count
    "(#{optionals} out of #{total})"
  end

  def optional_fields(application_criteria)
    application_criteria.questions.reject(&:required)
  end

  def mandatory_fields_only_disability(job_application)
    'disabled' if optional_fields(job_application.job.application_criterion).none?
  end

  def mandatory_fields_only_disability_cursor_class(job_application)
    '!cursor-not-allowed ' if optional_fields(job_application.job.application_criterion).none?
  end
end
