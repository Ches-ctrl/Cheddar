module Relevant
  extend ActiveSupport::Concern
  include Constants

  # rubocop:disable Style/OptionalBooleanParameter

  def relevant?(title, job_location, ignore_job_location = false)
    ignore_job_location = true if job_location.nil?

    puts "#{title} is relevant: #{JOB_TITLE_KEYWORDS.any? { |keyword| title&.downcase&.match?(keyword) }}"
    puts "#{job_location} is relevant: #{JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) }}"
    (title &&
    ignore_job_location &&
    JOB_TITLE_KEYWORDS.any? { |keyword| title.downcase.match?(keyword) }) ||
      (title &&
    job_location &&
    JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) } &&
    JOB_TITLE_KEYWORDS.any? { |keyword| title.downcase.match?(keyword) })
  end
end

# rubocop:enable Style/OptionalBooleanParameter
