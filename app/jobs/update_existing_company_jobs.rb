class UpdateExistingCompanyJobs < ApplicationJob
  include CompanyCsv
  include Relevant

  # Why do we get all the job urls?
  # Wouldn't the best approach here be to create a csv with all the company data from the respective APIs
  # Then we can query the APIs based on that data?

  # TODO: Update so that we have 2 processes:
  # TODO: (1) for all the existing jobs on the site, we check whether those are still live (and delete if not)
  # TODO: (2) for all the existing companies on the site, we check whether they have new jobs (and add if so)

  def perform
    puts "Beginning jobs updater for companies already seeded to the DB..."

    @job_urls = Job.all.to_set(&:job_posting_url)

    fetch_jobs_and_companies
    destroy_defunct_jobs
    # update_ats_identifiers_list
  end

  private

  def fetch_jobs_and_companies
    ats_list.each do |ats_name, ats_identifiers|
      # only prepared to handle some ATS systems at the moment
      next unless ['Greenhouse', 'Lever'].include?(ats_name)

      puts "Scanning #{ats_name} jobs:"
      @ats = ApplicantTrackingSystem.find_by(name: ats_name)

      ats_identifiers.each do |ats_identifier|
        puts "Looking at jobs with #{ats_identifier}..."

        # Find or create the company
        next puts "Problem with #{ats_identifier}" unless (company = @ats.find_or_create_company(ats_identifier))

        company_jobs = @ats.fetch_company_jobs(ats_identifier)

        # Create new jobs using AtsSystem method
        company_jobs.each do |job_data|
          @ats.find_or_create_job_by_data(company, job_data) if relevant?(job_data)
          @job_urls.delete(@ats.fetch_url(job_data))
        end
      end
    end
  end

  def relevant?(job_data)
    job_title, job_location = @ats_system.fetch_title_and_location(job_data)

    job_title &&
      job_location &&
      JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) } &&
      JOB_TITLE_KEYWORDS.any? { |keyword| job_title.downcase.match?(keyword) }
  end

  # TODO: Update this so that the jobs are kept but are no longer live on the site

  def destroy_defunct_jobs
    puts "Deleting jobs that are no longer live:"
    @job_urls.each do |job_posting_url|
      Job.find_by(job_posting_url:).destroy
      puts "Destroyed #{job_posting_url}"
    end
  end
end
