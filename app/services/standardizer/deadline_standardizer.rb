module Standardizer
  class DeadlineStandardizer
    def initialize(job)
      @job = job
    end

    def standardize
      @job.date_created ||= @job.created_at
      # @job.deadline ||= @job.date_created + 30.days
    end
  end
end
