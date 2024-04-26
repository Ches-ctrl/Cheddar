class CategorySidebar
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

  def self.build_with(jobs, params)
    @jobs = jobs
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
      when_posted: CONVERT_TO_DAYS.keys.reverse.to_h { |period| [period, 0] },
      seniorities: SENIORITIES.to_h { |seniority| [seniority, 0] },
      locations: Hash.new(0),
      roles: Hash.new(0),
      types: Hash.new(0),
      companies: Hash.new(0)
    }
    @date_cutoffs = CONVERT_TO_DAYS.transform_values { |v| v.days.ago.beginning_of_day }
    # TODO: look for ways to improve efficiency below. Converting to_set makes lookup faster.
    @jobs_with_any_posted = Job.including_any(@params, :posted).to_set
    @jobs_with_any_seniority = Job.including_any(@params, :seniority).to_set
    @jobs_with_any_location = Job.including_any(@params, :location).to_set
    @jobs_with_any_role = Job.including_any(@params, :role).to_set
    @jobs_with_any_type = Job.including_any(@params, :type).to_set
    @jobs_with_any_company = Job.including_any(@params, :company).to_set
  end

  private_class_method def self.update_category_hashes
    update_when_posted if @jobs_with_any_posted.include?(@job)
    update_seniorities if @jobs_with_any_seniority.include?(@job)
    update_locations if @jobs_with_any_location.include?(@job)
    update_roles if @jobs_with_any_role.include?(@job)
    update_types if @jobs_with_any_type.include?(@job)
    update_companies if @jobs_with_any_company.include?(@job)
  end

  private_class_method def self.build_resources_hash
    @resources = {}
    @count.each { |title, hash| @count[title] = hash.sort_by { |_k, v| -v }.to_h unless %i[when_posted seniorities].include?(title) }
    build_posted_array
    build_seniority_array
    build_location_array
    build_role_array
    build_type_array
    build_company_array
    @resources
  end

  private_class_method def self.update_when_posted
    date_created = @job.date_created.end_of_day
    @date_cutoffs.each do |period, cutoff|
      @count[:when_posted][period] += 1 if date_created > cutoff
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
        company.name,
        company.id,
        count,
        @params[:company]&.include?(company.id.to_s)
      ]
    end
  end
end
