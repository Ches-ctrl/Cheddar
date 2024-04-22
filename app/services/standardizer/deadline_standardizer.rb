module Standardizer
  class DeadlineStandardizer
    def initialize(job)
      @job = job
    end

    def standardize
      @job.date_posted ||= @job.created_at
      # @job.deadline ||= @job.date_posted + 30.days
    end
  end
end
