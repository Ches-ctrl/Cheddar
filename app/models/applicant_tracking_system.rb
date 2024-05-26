class ApplicantTrackingSystem < ApplicationRecord
  # == Constants ============================================================
  include CheckUrlIsValid
  include AtsSystemParser
  include Ats::UrlParser
  include Ats::CompanyCreator
  include Ats::JobCreator

  # == Attributes ===========================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================
  has_many :companies
  has_many :jobs, dependent: :destroy

  # == Validations ==========================================================
  validates :name, presence: true, uniqueness: true

  # == Scopes ===============================================================

  # == Callbacks ============================================================
  after_initialize :include_modules

  # == Class Methods ========================================================
  def self.determine_ats(url)
    name = ATS_SYSTEM_PARSER.find { |regex, ats_name| break ats_name if url.match?(regex) }
    return ApplicantTrackingSystem.find_by(name:)
  end

  def self.check_ats
    # TODO: Check if company is still hosted by an ATS or has moved provider (this actually may want to sit in CheckUrlIsValid)
  end

  # == Instance Methods =====================================================
  def include_modules
    return unless name

    module_name = name.gsub(/\W/, '').capitalize

    modules = [
      "Ats::#{module_name}::ParseUrl",
      "Ats::#{module_name}::CompanyDetails",
      "Ats::#{module_name}::FetchCompanyJobs",
      "Ats::#{module_name}::JobDetails",
      "Ats::#{module_name}::ApplicationFields",
      "Ats::#{module_name}::SubmitApplication"
    ]

    modules.each do |module_name|
      extend Object.const_get(module_name) if Object.const_defined?(module_name)
    end
  end

  def refer_to_module(method, method_name)
    return method if method

    puts "Write a #{method_name} method for #{name}!"
    return
  end

  # -----------------------
  # Time Conversions
  # -----------------------

  def convert_from_iso8601(iso8601_string)
    return Time.iso8601(iso8601_string) if iso8601_string
  end

  def convert_from_milliseconds(millisecond_string)
    Time.at(millisecond_string.to_i / 1000) if millisecond_string
  end
end
