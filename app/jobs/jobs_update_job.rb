class JobsUpdateJob < ApplicationJob
  include CompanyCsv
  include Relevant

  def perform
    puts "Beginning JobsUpdate..."

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
        puts "  Looking at jobs with #{ats_identifier}..."

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

  def destroy_defunct_jobs
    puts "Deleting jobs that are no longer live:"
    @job_urls.each do |job_posting_url|
      Job.find_by(job_posting_url:).destroy
      puts "  destroyed #{job_posting_url}"
    end
  end
end
