class JobFilter
  def initialize(params, scope = Job.all)
    @jobs = scope
    @params = params
  end

  def filter_and_sort
    jobs = @jobs
    jobs = apply_filters(jobs)
    apply_search(jobs)
  end

  def filter_by_department
    @jobs = @jobs.where(department: @params[:department]) if @params[:department].present?
    @jobs
  end

  private

  def apply_filters(jobs)
    filters = {
      date_posted: filter_by_when_posted(@params[:posted]),
      seniority: filter_by_seniority(@params[:seniority]),
      locations: filter_by_location(@params[:location]),
      roles: filter_by_role(@params[:role]),
      employment_type: filter_by_employment(@params[:type])
    }.compact

    associations = build_associations
    jobs.left_joins(associations).where(filters)
  end

  def build_associations
    associations = []
    associations << :company if @params.include?(:company)
    associations << :locations if @params.include?(:location)
    associations << :roles if @params.include?(:role)
    associations
  end

  def apply_search(jobs)
    return jobs unless @params[:query].present?

    jobs.search_job(@params[:query])
  end

  def filter_by_when_posted(param)
    return unless param.present?

    number = Constants::DateConversion::CONVERT_TO_DAYS[param] || 99_999
    number.days.ago..Date.today
  end

  def filter_by_location(param)
    return unless param.present?

    locations = param.split.map { |location| location.gsub('_', ' ').split.map(&:capitalize).join(' ') unless location == 'remote' }
    { city: locations }
  end

  def filter_by_role(param)
    { name: param.split } if param.present?
  end

  def filter_by_seniority(param)
    return unless param.present?

    param.split.map { |seniority| seniority.split('-').map(&:capitalize).join('-') }
  end

  def filter_by_employment(param)
    return unless param.present?

    param.split.map { |employment| employment.gsub('_', '-').capitalize }
  end
end
