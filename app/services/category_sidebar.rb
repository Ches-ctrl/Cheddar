class CategorySidebar
  CONVERT_TO_DAYS = {
    'today' => 0,
    '3-days' => 3,
    'week' => 7,
    'month' => 30,
    'any-time' => 99_999
  }

  def build
    # Where necessary, parse from Job.attributes
    locations = []
    jobs = Job.includes(:company, :roles, :locations).all
    jobs.each do |job|
      job.locations.includes(:country).each do |location|
        locations << (job.remote_only ? ["Remote (#{location.country})"] : [location.city, location.country&.name].compact)
      end
    end

    roles = jobs.inject([]) { |all_roles, job| all_roles + job.roles.map(&:name) }

    when_posted = ['Today', 'Last 3 days', 'Within a week', 'Within a month', 'Any time']

    seniorities = ['Internship', 'Entry-Level', 'Junior', 'Mid-Level', 'Senior', 'Director', 'VP', 'SVP / Partner']

    # For each item, store: [display_name, element_id, matching_jobs_count]
    resources = {}
    resources['posted'] = when_posted.map do |period|
      id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      count = jobs.count { |job| job.date_created.end_of_day > CONVERT_TO_DAYS[id].days.ago.beginning_of_day }
      [period, id, count] unless count.zero?
    end.compact
    resources['seniority'] = seniorities.map do |seniority|
      count = jobs.count { |job| job.seniority == seniority }
      [seniority, seniority.downcase.split.first, count] unless count.zero?
    end.compact
    resources['location'] = locations.compact.uniq.map do |location|
      [location.join(', '), location.first&.downcase&.gsub(' ', '_'), locations.count(location)]
    end
    resources['role'] = roles.uniq.map do |role|
      [role.split('_').map(&:titleize).join('-'), role, roles.count(role)]
    end
    resources['type'] = jobs.map(&:employment_type).uniq.map do |employment|
      [employment, employment.downcase.gsub('-', '_'), jobs.count { |job| job.employment_type == employment }]
    end
    resources['company'] = jobs.map(&:company).uniq.map do |company|
      [company.company_name, company.id, jobs.count { |job| job.company == company }]
    end

    resources.each { |title, array| array.sort_by! { |item| [-item[2]] } unless %w[posted seniority].include?(title) }
    return resources
  end
end
