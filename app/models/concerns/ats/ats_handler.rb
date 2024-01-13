module Ats::AtsHandler
  SUPPORTED_ATS_SYSTEMS = [
    'greenhouse',
    'workable',
    'lever',
    'smartrecruiters',
    'ashby',
    'totaljobs',
    'simplyhired',
    'workday',
    'tal.net',
    # 'indeed',
    # 'freshteam',
    # 'phenom',
    # 'jobvite',
    # 'icims',
    # Add other supported ATS systems here
  ].freeze

  def initialize(url_or_job)
    if url_or_job.is_a?(String)
      @url = url_or_job
    else
      @job = url_or_job
      @url = @job.job_posting_url
    end
  end

  def ats_system
    @ats_system ||= SUPPORTED_ATS_SYSTEMS.find { |ats| @url.include?(ats) }
  end

  # TODO: Update module to handle submodules when splitting out ATS capabilities

  def ats_module(action)
    module_name = "Ats::#{ats_system.capitalize}::#{action}"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end

  def get_company_details
    ats_module.get_company_details(@url)
  end

  def get_job_details
    ats_module.get_job_details(@job)
  end
end
