class CategorySidebar
  WHEN_POSTED = [
    'Today',
    'Last 3 days',
    'Within a week',
    'Within a month',
    'Any time'
  ]
  SENIORITIES = [
    'Internship',
    'Entry-Level',
    'Junior',
    'Mid-Level',
    'Senior',
    'Director',
    'VP',
    'SVP / Partner'
  ]
  CONVERT_TO_DAYS = {
    'Today' => 0,
    'Last 3 days' => 3,
    'Within a week' => 7,
    'Within a month' => 30,
    'Any time' => 99_999
  }

  def self.build_with(params)
    @params = params
    Rails.cache.fetch('category_sidebar', expires_in: 2.hours, race_condition_ttl: 10.seconds) do
      fetch_sidebar_data
    end
  end

  private

  private_class_method def self.fetch_sidebar_data
    initialize_category_hashes

    jobs = Job.includes(:company, :roles, :locations, :countries).all
    jobs.each do |job|
      @job = job
      update_category_hashes
    end

    build_resources_hash
  end

  private_class_method def self.initialize_category_hashes
    @count = {
      when_posted: CONVERT_TO_DAYS.keys.to_h { |period| [period, 0] },
      seniorities: SENIORITIES.to_h { |seniority| [seniority, 0] },
      locations: Hash.new(0),
      roles: Role.all.to_h { |role| [role.name, 0] },
      types: Hash.new(0),
      companies: Hash.new(0)
    }
  end

  private_class_method def self.update_category_hashes
    update_when_posted
    update_seniorities
    update_locations
    update_roles
    update_types
    update_companies
  end

  private_class_method def self.build_resources_hash
    @resources = {}
    @count.each { |title, hash| @count[title] = hash.sort_by { |_k, v| -v }.to_h unless %i[posted seniorities].include?(title) }
    build_posted_array
    build_seniority_array
    build_location_array
    build_role_array
    build_type_array
    build_company_array
    @resources
  end

  private_class_method def self.update_when_posted
    CONVERT_TO_DAYS.each_key do |k|
      @count[:when_posted][k] += 1 if @job.date_created.end_of_day > CONVERT_TO_DAYS[k].days.ago.beginning_of_day
    end
  end

  private_class_method def self.update_seniorities
    level = @job.seniority
    @count[:seniorities][level] += 1 if @count[:seniorities][level]
  end

  private_class_method def self.update_locations
    if @job.remote_only
      @count[:locations][['Remote Only']] += 1
    else
      @job.locations.includes(:country).each do |location|
        name = [location.city, location.country&.name].compact
        @count[:locations][name] = (@count[:locations][name] || 0) + 1
      end
    end
  end

  private_class_method def self.update_roles
    @job.roles.each do |role|
      name = role.name
      @count[:roles][name] += 1 if @count[:roles][name]
    end
  end

  private_class_method def self.update_types
    type = @job.employment_type
    @count[:types][type] += 1
  end

  private_class_method def self.update_companies
    company = @job.company
    @count[:companies][company] += 1
  end

  private_class_method def self.build_posted_array
    @resources['posted'] = @count[:when_posted].map do |period, count|
      next if count.zero?

      period_id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      [
        'radio',
        period,
        period_id,
        count,
        @params[:posted] ? @params[:posted].include?(period_id) : period == 'Any time'
      ]
    end.compact
  end

  private_class_method def self.build_seniority_array
    @resources['seniority'] = @count[:seniorities].map do |seniority, count|
      next if count.zero?

      seniority_id = seniority.downcase.split.first
      [
        'checkbox',
        seniority,
        seniority_id,
        count,
        @params[:seniority]&.include?(seniority_id)
      ]
    end.compact
  end

  private_class_method def self.build_location_array
    @resources['location'] = @count[:locations].take(15).map do |location, count|
      location_id = location.first&.downcase&.gsub(' ', '_')
      [
        'checkbox',
        location.join(', '),
        location_id,
        count,
        @params[:location]&.include?(location_id)
      ]
    end
  end

  private_class_method def self.build_role_array
    @resources['role'] = @count[:roles].map do |role, count|
      [
        'checkbox',
        role.split('_').map(&:titleize).join('-'),
        role,
        count,
        @params[:role]&.include?(role)
      ]
    end
  end

  private_class_method def self.build_type_array
    @resources['type'] = @count[:types].map do |type, count|
      [
        'checkbox',
        type,
        type.downcase.gsub('-', '_'),
        count,
        @params[:type]&.include?(type)
      ]
    end
  end

  private_class_method def self.build_company_array
    @resources['company'] = @count[:companies].take(15).map do |company, count|
      [
        'checkbox',
        company.company_name,
        company.id,
        count,
        @params[:company]&.include?(company.id.to_s)
      ]
    end
  end
end
