class JobFilter
  def initialize(params)
    p "hello filter"
    @jobs = Job.all
    @params = params
  end

  def filter_and_sort
    p "hello filter and sort"
    filters = {
      date_posted: filter_by_when_posted(@params[:posted]),
      seniority: filter_by_seniority(@params[:seniority]),
      locations: filter_by_location(@params[:location]),
      roles: filter_by_role(@params[:role]),
      employment_type: filter_by_employment(@params[:type])
    }.compact

    associations = build_associations
    jobs = @jobs.left_joins(associations).where(filters)
    @params[:query].present? ? jobs.search_job(@params[:query]) : jobs
  end

  private

  def build_associations
    associations = []
    associations << :company if @params.include?(:company)
    associations << :locations if @params.include?(:location)
    associations << :roles if @params.include?(:role)
    associations
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
