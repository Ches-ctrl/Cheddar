class DeadlineStandardizer
  def initialize(job)
    @job = job
  end

  def standardize
    @job.date_created ||= @job.created_at
    @job.application_deadline ||= @job.date_created + 30.days
    p @job.application_deadline
  end
end
