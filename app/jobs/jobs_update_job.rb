class JobsUpdateJob < ApplicationJob
  include Constants
  include HashBuilder

  def perform
    puts "Beginning JobsUpdate..."

    companies = build_ats_companies
    @job_urls = Job.all.to_set(&:job_posting_url)

    companies.each do |ats_name, ats_identifiers|
      # only prepared to handle some ATS systems at the moment
      next unless [:greenhouse].include?(ats_name)

      puts "Scanning #{ats_name.to_s} jobs:"
      ats_system = ApplicantTrackingSystem.find_by(name: ats_name.to_s.capitalize)

      ats_identifiers.each do |ats_identifier|
        puts "  Looking at jobs with #{ats_identifier}..."

        # Find or create the company
        puts "problem with #{ats_identifier}" unless (company = ats_system.company_details.get_company_details(ats_system, ats_identifier))
        next unless (company_jobs = ats_system.fetch_company_jobs(ats_identifier))

        # Create new jobs using AtsSystem method
        company_jobs.each do |job_data|
          Job.create_job(ats_system, company, job_data) if relevant?(job_data)
          # ats_system.job_details.create_or_update_job(job_data, company) if relevant?(job_data['title'])
          @job_urls.delete(job_data['absolute_url'])
        end
      end
    end

    # Delete defunct jobs
    destroy_defunct_jobs
  end

  private

  def relevant?(job_data)
    job_title = job_data['title']
    job_location = job_data['location']['name']

    JOB_LOCATION_KEYWORDS.any? { |keyword| job_location.downcase.match?(keyword) } &&
      JOB_TITLE_KEYWORDS.any? { |keyword| job_title.downcase.match?(keyword) }
  end

  def destroy_defunct_jobs
    puts "Deleting jobs that are no longer live:"
    @job_urls.each do |job_posting_url|
      Job.find_by(job_posting_url:).destroy
      puts "  destroyed #{job_posting_url}"
    end
  end
end
