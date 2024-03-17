class UpdateRelevantJobs
  include Filters
  include HashBuilder
  include CompanyCreator

  # TODO: change queue_as to deprioritised relative to job applications
  queue_as :default

  def initialize
    @companies = build_ats_companies
    @job_urls = Job.all.to_set(&:job_posting_url)
  end

  def update_jobs
    @companies.each do |ats_name, ats_identifiers|
      # only prepared to handle some ATS systems at the moment
      next unless [:greenhouse].include?(ats_name)

      puts "Scanning #{ats_name.to_s} jobs:"
      ats_system = ApplicantTrackingSystem.find_by(name: ats_name.to_s.capitalize)

      ats_identifiers.each do |ats_identifier|
        puts "  Looking at jobs with #{ats_identifier}..."

        # Find or create the company
        puts ats_identifier unless (company = ats_system.company_details.get_company_details(ats_system, ats_identifier))
        next unless (company_jobs = ats_system.fetch_company_jobs(ats_identifier))

        # Create new jobs using AtsSystem method
        company_jobs.each do |job_data|
          ats_system.job_details.create_or_update(job_data, company) if relevant?(job_data['title'])
          @job_urls.delete(job_data['absolute_url'])
        end
      end
    end

    # Delete defunct jobs
    destroy_defunct_jobs
  end

  private

  def relevant?(job_title)
    job_title.match?(JOB_TITLE_KEYWORDS)
  end

  def destroy_defunct_jobs
    puts "Deleting jobs that are no longer live:"
    @job_urls.each do |job_posting_url|
      Job.find(job_posting_url:).destroy
      puts "  destroyed #{job_posting_url}"
    end
  end
end
