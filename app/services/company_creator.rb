class CompanyCreator
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
  ].freeze

  def initialize(url)
    @url = url
  end

  def find_or_create_company
    ats_system = SUPPORTED_ATS_SYSTEMS.find { |ats| @url.include?(ats) }

    if ats_system
      ats_module = get_ats_module(ats_system)
      ats_module.get_company_details(@url)
    else
      p "Unable to detect ATS system for URL: #{@url}"
      return nil
    end
  end

  def get_ats_module(ats_system)
    module_name = "Ats::#{ats_system.capitalize}"
    Object.const_get(module_name) if Object.const_defined?(module_name)
  end
end
