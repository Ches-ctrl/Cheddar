module OpportunityHelper
  def job_saved?(opportunity)
    @current_saved_job_ids ||= current_user.saved_jobs.pluck(:job_id)
    @current_saved_job_ids.include?(opportunity.id)
  end

  def opportunity_public_location(opportunity)
    text = if opportunity.remote || opportunity.locations.empty?
             'Remote'
           else
             opportunity.locations.map(&:city).join(' | ')
           end
    text += ", #{opportunity.countries.first.name}" if opportunity.countries.size == 1
    text
  end

  def opportunity_public_employment_type(opportunity)
    employment_type = opportunity.employment_type
    location_type = if opportunity.remote
                      "Remote"
                    elsif opportunity.hybrid
                      "Hybrid"
                    else
                      "In-office"
                    end
    "#{employment_type} • #{location_type}"
  end

  def opportunity_salary_presentation(opportunity)
    opportunity.salary.present? ? opportunity.salary : nil
  end

  def opportunity_days_remaining(opportunity)
    opportunity.deadline.nil? || opportunity.deadline < Date.today ? "Rolling" : opportunity.deadline.strftime("%d/%m")
  end

  def seniority_css(opportunity, seniority)
    # TODO: Fix this once seniority is already defined (at the moment this manages nil values)
    return nil unless opportunity.seniority&.include?(seniority)

    ' text-gray-300 dark:text-gray-700'
  end
end
