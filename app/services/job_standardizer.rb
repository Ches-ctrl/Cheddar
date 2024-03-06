class JobStandardizer
  def initialize(job)
    @job = job
  end

  def standardize
    RoleStandardizer.new(@job).standardize
    SeniorityStandardizer.new(@job).standardize
    LocationStandardizer.new(@job).standardize
    DeadlineStandardizer.new(@job).standardize
    SalaryStandardizer.new(@job).standardize
    @job.save
  end
end
