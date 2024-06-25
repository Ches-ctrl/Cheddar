class ApplicantTrackingSystem < ApplicationRecord
  # == Constants ============================================================
  include CheckUrlIsValid
  include AtsSystemParser
  include Ats::UrlParser
  include Ats::CompanyCreator
  include Ats::JobCreator

  ATS_MODULES = %w[
    ParseUrl
    CompanyDetails
    FetchCompanyJobs
    JobDetails
    ApplicationFields
    SubmitApplication
  ].freeze

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
    name = fetch_ats_name_from_url(url)
    return ApplicantTrackingSystem.find_by(name:)
  end

  def self.check_ats
    # TODO: Check if company is still hosted by an ATS or has moved provider (this actually may want to sit in CheckUrlIsValid)
  end

  # == Instance Methods =====================================================

  # -----------------------
  # Include relevant modules
  # -----------------------

  def include_modules
    return unless name

    module_name = name.gsub(/\W/, '').capitalize

    ATS_MODULES.each do |mod|
      full_module_name = "Ats::#{module_name}::#{mod}"
      extend Object.const_get(full_module_name) if Object.const_defined?(full_module_name)
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

  private_class_method def self.fetch_ats_name_from_url(url)
    url_path, url_parameters = url.split('?')
    fetch_name(url_path) || fetch_name(url_parameters)
  end

  private_class_method def self.fetch_name(string)
    return if string.empty?

    ATS_SYSTEM_PARSER.find { |regex, ats_name| break ats_name if string.match?(regex) }
  end
end
