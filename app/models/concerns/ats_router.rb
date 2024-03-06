module AtsRouter
  # TODO: Handle embedded pages with differing URL structures
  # TODO: Create mapping (based on JobsAPIs) that maps the different information structures for each ATS system

  SUPPORTED_ATS_SYSTEMS = [
    'greenhouse',
    'workable',
    'lever',
    'smartrecruiters',
    'ashbyhq',
    'pinpointhq',
    'bamboohr',
    'recruitee',
    'manatal',
    # 'totaljobs',
    # 'simplyhired',
    # 'workday',
    # 'tal.net',
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
    @ats_system_name ||= 'greenhouse' if @url.include?('gh_jid')
    @ats_system_name ||= 'manatal' if @url.include?('careers-page')
    @ats_system_name
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

  def get_application_criteria
    p "Getting application criteria"
    ats_module.get_application_criteria(@job)
  end
end
