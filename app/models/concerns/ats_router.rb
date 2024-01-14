module AtsRouter
  # TODO: Handle embedded pages with differing URL structures

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

  def ats_system_name
    @ats_system_name ||= SUPPORTED_ATS_SYSTEMS.find { |ats| @url.include?(ats) }
  end

  def ats_system
    @ats_system = ApplicantTrackingSystem.find_by(name: ats_system_name.capitalize)
  end

  def ats_module(action)
    module_name = "Ats::#{ats_system_name.capitalize}::#{action}"
    @ats_module = Object.const_get(module_name) if Object.const_defined?(module_name)
  end

  def ats_identifier_and_job_id
    @ats_identifier, @job_id = ats_module('ParseUrl').parse_url(@url)
    [@ats_identifier, @job_id]
  end

  def get_company_details
    ats_module.get_company_details(@url)
  end

  def get_job_details
    ats_module.get_job_details(@job)
  end
end
