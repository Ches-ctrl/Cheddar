class ApplyJob < ApplicationJob
  include Defaults::DefaultMale
  include Defaults::DefaultFemale

  queue_as :default
  sidekiq_options retry: false

  def perform(job_application_id, user_id)
    JobApplication::ApplyJob.new(user_id, job_application_id).call
  end
end
