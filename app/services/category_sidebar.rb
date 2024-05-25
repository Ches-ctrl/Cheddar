class CategorySidebar
  include Constants::CategorySidebar

  def initialize(params)
    @params = params
    @jobs = Job.includes(:roles, :locations).select("jobs.id, jobs.date_posted, jobs.seniority, jobs.remote, jobs.employment_type")
  end

  def build
    [fetch_sidebar_data, @jobs.size]
  end

  private

  def fetch_sidebar_data
    initialize_category_hashes
    build_resources_hash
  end

  def initialize_category_hashes
    @date_cutoffs = CONVERT_TO_DAYS.transform_values { |v| v.days.ago.beginning_of_day }
    @jobs_with_any_posted = @jobs.including_any(@params, :posted)
    @jobs_with_any_seniority = @jobs.including_any(@params, :seniority)
    @jobs_with_any_location = @jobs.including_any(@params, :location)
                                   .joins(jobs_locations: :location)
    @jobs_with_no_location = @jobs.including_any(@params, :location)
                                  .where.missing(:jobs_locations)
    @jobs_with_any_role = @jobs.including_any(@params, :role)
    @jobs_with_any_type = @jobs.including_any(@params, :type)
  end

  def build_resources_hash
    @resources = {}
    build_posted_array
    build_seniority_array
    build_location_array
    build_role_array
    build_type_array
    @resources
  end

  def build_posted_array
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

  def build_seniority_array
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

  def build_location_array
    locations = Location.joins(:country).select("locations.city AS city, locations.country_id, countries.name AS country_name").map do |location|
      city = location.city
      country = location.country_name
      location_id = city.downcase.gsub(' ', '_')
      count = @jobs_with_any_location.where("locations.city = ?", city)
                                     .size
      next if count.zero?

      [
        'checkbox',
        [city, country].join(', '),
        location_id,
        count,
        @params[:location]&.include?(location_id)
      ]
    end.compact
    locations << [
      'checkbox',
      'Remote',
      'remote',
      @jobs_with_no_location.size,
      @params[:location]&.include?('remote')
    ]
    @resources['location'] = locations.sort_by { |_, _, _, count, _| -count }.take(10)
  end

  def build_role_array
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

  def build_type_array
    @resources['type'] = EMPLOYMENT_TYPES.map do |type|
      count = @jobs_with_any_type.where(employment_type: type).size
      next if count.zero?

      [
        'checkbox',
        type,
        type.downcase.gsub('-', '_'),
        count,
        @params[:type]&.include?(type)
      ]
    end.compact
  end
end
