module Relevant
  extend ActiveSupport::Concern
  include Constants

  def relevant?(title, job_location, ignore_job_location = false)
    # puts "#{title} is relevant: #{JOB_TITLE_KEYWORDS.any? { |keyword| title&.downcase&.match?(keyword) }}"
    # puts "#{job_location} is relevant: #{JOB_LOCATION_KEYWORDS.any? { |keyword| job_location&.downcase&.match?(keyword) }}"

    ignore_job_location = true if job_location.nil?

    (ignore_job_location && relevant_based_on?(title)) ||
      relevant_based_on?(title, job_location)
  end

  private

  def relevant_based_on?(title, job_location = nil)
    job_location ? relevant_based_on_title_and_location?(title, job_location) : relevant_based_on_job_title?(title)
  end

  def relevant_based_on_job_title?(title)
    title &&
      JOB_TITLE_KEYWORDS.any? { |keyword| title.downcase.match?(keyword) }
  end

  def relevant_based_on_title_and_location?(title, job_location)
    title &&
      job_location &&
      JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.match?(keyword) } &&
      JOB_TITLE_KEYWORDS.any? { |keyword| title.match?(keyword) }
  end
end
