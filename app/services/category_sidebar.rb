class CategorySidebar
  CONVERT_TO_DAYS = {
    'today' => 0,
    '3-days' => 3,
    'week' => 7,
    'month' => 30,
    'any-time' => 99_999
  }

  def initialize(params)
    @params = params
  end

  def build
    # Where necessary, parse from Job.attributes
    jobs = Job.includes(:company, :roles, :locations, :countries).all

    locations = []
    jobs.each do |job|
      if job.remote_only
        locations << ["Remote (#{job.countries.map(&:name).join(', ')})"]
      else
        job.locations.includes(:country).each do |location|
          locations << [location.city, location.country&.name].compact
        end
      end
    end

    roles = jobs.inject([]) { |all_roles, job| all_roles + job.roles.map(&:name) }

    when_posted = ['Today', 'Last 3 days', 'Within a week', 'Within a month', 'Any time']

    seniorities = ['Internship', 'Entry-Level', 'Junior', 'Mid-Level', 'Senior', 'Director', 'VP', 'SVP / Partner']

    # For each item, store: [type, display_name, element_id, matching_jobs_count, checked]
    resources = {}
    resources['posted'] = when_posted.map do |period|
      id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      count = jobs.count { |job| job.date_created.end_of_day > CONVERT_TO_DAYS[id].days.ago.beginning_of_day }
      [
        'radio',
        period,
        id,
        count,
        @params[:posted] ? @params[:posted].include?(id) : period == 'Any time'
      ] unless count.zero?
    end.compact
    resources['seniority'] = seniorities.map do |seniority|
      count = jobs.count { |job| job.seniority == seniority }
      [
        'checkbox',
        seniority,
        seniority.downcase.split.first,
        count,
        @params[:seniority]&.include?(seniority.downcase.split.first)
      ] unless count.zero?
    end.compact
    resources['location'] = locations.compact.uniq.map do |location|
      [
        'checkbox',
        location.join(', '),
        location.first&.downcase&.gsub(' ', '_'),
        locations.count(location),
        @params[:location]&.include?(location.first&.downcase&.gsub(' ', '_'))
      ]
    end
    resources['role'] = roles.uniq.map do |role|
      [
        'checkbox',
        role.split('_').map(&:titleize).join('-'),
        role,
        roles.count(role),
        @params[:role]&.include?(role)
      ]
    end
    resources['type'] = jobs.map(&:employment_type).uniq.map do |employment|
      [
        'checkbox',
        employment,
        employment.downcase.gsub('-', '_'),
        jobs.count { |job| job.employment_type == employment },
        @params[:type]&.include?(employment)
      ]
    end
    resources['company'] = jobs.map(&:company).uniq.map do |company|
      [
        'checkbox',
        company.company_name,
        company.id,
        jobs.count { |job| job.company == company },
        @params[:company]&.include?(company.id.to_s)
      ]
    end

    resources.each { |title, array| array.sort_by! { |item| [-item[3]] } unless %w[posted seniority].include?(title) }
    return resources
  end
end
