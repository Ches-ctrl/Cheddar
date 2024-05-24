# app/helpers/job_listings_helper.rb
module JobListingsHelper
  def partition_jobs(jobs)
    jobs.partition { |job| job.department.present? }
  end
end
