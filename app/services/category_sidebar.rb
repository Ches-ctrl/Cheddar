class CategorySidebar
  include Constants::CategorySidebar

  def initialize(filtered_jobs, params)
    @params = params

    # Leaving this here as presumably we need to pass the sorted jobs to the sidebar?
    # @filtered_jobs = filtered_jobs.eager_load(:roles, :locations)
    @filtered_jobs = jobs_collection(filtered_jobs)
  end

  def build
    [fetch_sidebar_data, @filtered_jobs.size]
  end

  private

  def fetch_sidebar_data
    build_resources_hash
  end

  def build_resources_hash
    @resources = {}
    build_posted_array
    build_seniority_array
    build_location_array
    build_role_array
    build_employment_array
    @resources
  end

  def build_posted_array
    jobs_any_posted = exclude_from_filters(:posted)
    date_cutoffs = CONVERT_TO_DAYS.transform_values { |v| v.days.ago.beginning_of_day }
    results = date_cutoffs.map do |period, cutoff|
      period_id = period.downcase.gsub(/last |within a /, '').gsub(' ', '-')
      count = jobs_any_posted.where(date_posted: cutoff..Date.today).count
      params = @params[:posted] ? @params[:posted].include?(period_id) : period == 'Any time'

      ['radio', period, period_id, count, params]
    end.compact
    @resources['posted'] = results
  end

  def build_seniority_array
    jobs_any_seniority = exclude_from_filters(:seniority)
    results = jobs_collection(jobs_any_seniority).group(:seniority).count.map do |seniority, count|
      next unless seniority

      seniority_id = seniority.downcase.split.first
      params = @params[:seniority]&.include?(seniority_id)

      ['checkbox', seniority, seniority_id, count, params]
    end.compact
    @resources['seniority'] = results
  end

  def build_location_array
    jobs_any_location = exclude_from_filters(:location)
    results = jobs_collection(jobs_any_location).group(:'locations.city').count.map do |location, count|
      location_id = location ? location.downcase.gsub(' ', '_') : 'remote'
      params = location ? @params[:location]&.include?(location_id) : @params[:location]&.include?('remote')
      location ||= 'Remote'

      ['checkbox', location, location_id, count, params]
    end.compact
    @resources['location'] = sort_by_count_desc(results)
  end

  def build_role_array
    jobs_any_role = exclude_from_filters(:role)
    results = jobs_collection(jobs_any_role).group(:'roles.name').count.map do |role, count|
      next unless role

      role_id = role
      params = @params[:role]&.include?(role_id)
      role = role.titleize

      ['checkbox', role, role_id, count, params]
    end.compact
    @resources['role'] = sort_by_count_desc(results)
  end

  def build_employment_array
    jobs_any_employment = exclude_from_filters(:employment)
    results = jobs_collection(jobs_any_employment).group(:employment_type).count.map do |employment, count|
      next unless employment

      employment_id = employment.downcase.gsub('-', '_')
      params = @params[:employment]&.include?(employment_id)

      ['checkbox', employment, employment_id, count, params]
    end.compact
    @resources['employment'] = sort_by_count_desc(results)
  end

  def sort_by_count_desc(data)
    data.sort_by { |item| -item[3] }
  end

  def exclude_from_filters(category)
    JobFilter.new(@params.except(category)).filter_and_sort
  end

  def jobs_collection(filtered_jobs)
    Job.where(id: filtered_jobs.pluck(:id)).eager_load(:roles, :locations)
  end
end
