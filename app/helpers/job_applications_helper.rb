module JobApplicationsHelper
  def attachment_required_but_absent?(application_criteria, attachment)
    application_criteria.required && !attachment.attached?
  end
end
