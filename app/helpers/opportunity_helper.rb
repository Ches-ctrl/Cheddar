module OpportunityHelper
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
end
