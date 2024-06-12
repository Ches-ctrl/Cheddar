module Standardizer
  class JobStandardizer
    def initialize(job)
      @job = job
    end

    def standardize
      Standardizer::TermStandardizer.new(@job).standardize
      Standardizer::RoleStandardizer.new(@job).standardize
      Standardizer::SeniorityStandardizer.new(@job).standardize
      Standardizer::LocationStandardizer.new(@job).standardize
      Standardizer::DeadlineStandardizer.new(@job).standardize
      Standardizer::SalaryStandardizer.new(@job).standardize
      @job.save!
    end
  end
end
