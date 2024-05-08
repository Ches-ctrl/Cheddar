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
  ROLES = {
    'front_end' => 'Front End',
    'back_end' => 'Back End',
    'full_stack' => 'Full Stack',
    'dev_ops' => 'Dev Ops',
    'qa_test_engineer' => 'QA/Test Engineer',
    'mobile' => 'Mobile',
    'data_engineer' => 'Data Engineer'
  }
  EMPLOYMENT_TYPES = [
    'Full-time',
    'Permanent',
    'Contract',
    'Part-time'
  ]
  CONVERT_TO_DAYS = {
    'Any time' => 99_999,
    'Within a month' => 30,
    'Within a week' => 7,
    'Last 3 days' => 3,
    'Today' => 0
  }

  def self.build_with(params)
    @params = params
    @jobs = Job.includes(:roles, :locations).select("jobs.id, jobs.date_posted, jobs.seniority, jobs.remote, jobs.employment_type")
    Rails.cache.fetch("category_sidebar #{@params.except(:page, :controller, :action)}", expires_in: 2.hours, race_condition_ttl: 10.seconds) do
      fetch_sidebar_data
    end
  end

  private

  private_class_method def self.fetch_sidebar_data
    initialize_category_hashes
    build_resources_hash
  end

  private_class_method def self.initialize_category_hashes
    @date_cutoffs = CONVERT_TO_DAYS.transform_values { |v| v.days.ago.beginning_of_day }
    @jobs_with_any_posted = @jobs.including_any(@params, :posted)
    @jobs_with_any_seniority = @jobs.including_any(@params, :seniority)
    @jobs_with_any_location = @jobs.including_any(@params, :location)
                                   .joins(jobs_locations: :location)
    @jobs_with_no_location = @jobs.including_any(@params, :location)
                                  .where.missing(:jobs_locations)
    @jobs_with_any_role = @jobs.including_any(@params, :role)
    @jobs_with_any_type = @jobs.including_any(@params, :type)
    @jobs_with_any_company = @jobs.including_any(@params, :company)
  end

  private_class_method def self.build_resources_hash
    @resources = {}
    build_posted_array
    build_seniority_array
    build_location_array
    build_role_array
    build_type_array
    @resources
  end

  private_class_method def self.build_posted_array
    @resources['posted'] = @date_cutoffs.map do |period, cutoff|

      period_id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      [
        'radio',
        period,
        period_id,
        @jobs_with_any_posted.where(date_posted: cutoff..Date.today).size,
        @params[:posted] ? @params[:posted].include?(period_id) : period == 'Any time'
      ]
    end.compact
  end

  private_class_method def self.build_seniority_array
    @resources['seniority'] = SENIORITIES.map do |seniority|
      seniority_id = seniority.downcase.split.first
      count = @jobs_with_any_seniority.where(seniority:).size
      next if count.zero?

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
    locations = Location.joins(:country).select("locations.city AS city, locations.country_id, countries.name AS country_name").map do |location|
      city = location.city
      country = location.country_name
      location_id = city.downcase.gsub(' ', '_')
      count = @jobs_with_any_location.where("locations.city = ?", city)
                                     .size
      [
        'checkbox',
        [city, country].join(', '),
        location_id,
        count,
        @params[:location]&.include?(location_id)
      ]
    end
    locations << [
      'checkbox',
      'Remote',
      'remote',
      @jobs_with_no_location.size,
      @params[:location]&.include?('remote')
    ]
    @resources['location'] = locations.sort_by { |_, _, _, count, _| -count }.take(10)
  end

  private_class_method def self.build_role_array
    @resources['role'] = ROLES.map do |role_id, role|
      count = @jobs_with_any_role.joins(jobs_roles: :role)
                                 .where("roles.name = ?", role_id)
                                 .size
      next if count.zero?

      [
        'checkbox',
        role,
        role_id,
        count,
        @params[:role]&.include?(role_id)
      ]
    end.compact
  end

  private_class_method def self.build_type_array
    @resources['type'] = EMPLOYMENT_TYPES.map do |type|
      [
        'checkbox',
        type,
        type.downcase.gsub('-', '_'),
        @jobs_with_any_type.where(employment_type: type).size,
        @params[:type]&.include?(type)
      ]
    end
  end

  # private_class_method def self.update_when_posted
  #   date_posted = @job.date_posted.end_of_day
  #   @date_cutoffs.each do |period, cutoff|
  #     @count[:when_posted][period] += 1 if date_posted > cutoff
  #   end
  # end

  # private_class_method def self.update_seniorities
  #   level = @job.seniority
  #   @count[:seniorities][level] += 1 if @count[:seniorities][level]
  # end

  # private_class_method def self.update_locations
  #   if @job.remote
  #     @count[:locations][['remote']] += 1
  #   else
  #     @job.locations.includes(:country).each do |location|
  #       name = [location.city, location.country&.name].compact
  #       @count[:locations][name] = (@count[:locations][name] || 0) + 1
  #     end
  #   end
  # end

  # private_class_method def self.update_roles
  #   @job.roles.each do |role|
  #     name = role.name
  #     @count[:roles][name] += 1 if @count[:roles][name]
  #   end
  # end

  # private_class_method def self.update_types
  #   type = @job.employment_type
  #   @count[:types][type] += 1
  # end

  # private_class_method def self.update_companies
  #   company = [@job.company_name, @job.company_id]
  #   @count[:companies][company] += 1
  # end

  # private_class_method def self.build_posted_array
  #   @resources['posted'] = @count[:when_posted].map do |period, count|
  #     next if count.zero?

  #     period_id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
  #     [
  #       'radio',
  #       period,
  #       period_id,
  #       count,
  #       @params[:posted] ? @params[:posted].include?(period_id) : period == 'Any time'
  #     ]
  #   end.compact
  # end

  # private_class_method def self.build_seniority_array
  #   @resources['seniority'] = @count[:seniorities].map do |seniority, count|
  #     next if count.zero?

  #     seniority_id = seniority.downcase.split.first
  #     [
  #       'checkbox',
  #       seniority,
  #       seniority_id,
  #       count,
  #       @params[:seniority]&.include?(seniority_id)
  #     ]
  #   end.compact
  # end

  # private_class_method def self.build_location_array
  #   @resources['location'] = @count[:locations].take(15).map do |location, count|
  #     location_id = location.first&.downcase&.gsub(' ', '_')
  #     [
  #       'checkbox',
  #       location.join(', '),
  #       location_id,
  #       count,
  #       @params[:location]&.include?(location_id)
  #     ]
  #   end
  # end

  # private_class_method def self.build_role_array
  #   @resources['role'] = @count[:roles].map do |role, count|
  #     [
  #       'checkbox',
  #       role.split('_').map(&:titleize).join('-'),
  #       role,
  #       count,
  #       @params[:role]&.include?(role)
  #     ]
  #   end
  # end

  # private_class_method def self.build_type_array
  #   @resources['type'] = @count[:types].map do |type, count|
  #     [
  #       'checkbox',
  #       type,
  #       type.downcase.gsub('-', '_'),
  #       count,
  #       @params[:type]&.include?(type)
  #     ]
  #   end
  # end

  # private_class_method def self.build_company_array
  #   @resources['company'] = @count[:companies].take(15).map do |company, count|
  #     [
  #       'checkbox',
  #       company.first,
  #       company.second,
  #       count,
  #       @params[:company]&.include?(company.id.to_s)
  #     ]
  #   end
  # end
end
