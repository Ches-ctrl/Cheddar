module Relevant
  extend ActiveSupport::Concern
  include Constants

  def relevant?(job_data)
    title, job_location = @ats.fetch_title_and_location(job_data)

    title &&
      job_location &&
      JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) } &&
      JOB_TITLE_KEYWORDS.any? { |keyword| title.downcase.match?(keyword) }
  end
end
