class UpdateRelevantJobs
  include AtsRouter
  include HashBuilder
  include CompanyCreator

  def initialize
    @companies = build_ats_companies
    @unique_jobs = build_unique_jobs.to_set
  end

  def update_jobs
    @companies.each do |ats_name, ats_identifiers|
      # only prepared to handle some jobs at the moment
      next unless [:greenhouse].include?(ats_name)

      puts "Scanning #{ats_name.to_s} jobs:"
      ats_system = ApplicantTrackingSystem.find_by(name: ats_name.to_s.capitalize)

      ats_identifiers.each do |ats_identifier|
        puts "  Looking at jobs with #{ats_identifier}..."

        # Find or create the company
        company = ats_system.company_details.get_company_details(ats_system, ats_identifier)
        company_jobs = ats_system.fetch_company_jobs(ats_identifier)
        next unless company_jobs

        # Remove obsolete job listings from db
        urls = company_jobs.map { |job_data| job_data['absolute_url'] }
        company.jobs.each do |job|
          unless urls.include?(job.job_posting_url)
            puts "Cleared defunct job: #{job.job_posting_url}"
            job.destroy
          end
        end

        # Create new jobs with jobs_controller
        company_jobs.each do |job_data|
          if is_relevant?(job_data['title'])
            # use job_controller
            ats_system.job_details.create_or_update(job_data, company)

          end
        end

        # Iterate through the jobs, discard if irrelevant, find or save otherwise.
      end
    end
  end

  def fetch_jobs
    jobs_data = @companies.inject(Set.new) do |combined_data, (ats_name, company_ids)|
      puts "Scanning #{ats_name.to_s} jobs:"
      combined_data + company_ids.inject(Set.new) do |ats_data, company_id|
        next ats_data + @descriptions[company_id] unless @descriptions[company_id].empty?

        puts "  Looking at jobs with #{company_id}..."
        @ats_identifier = company_id
        next ats_data unless (company_data = fetch_tagged_jobs(ats_name))

        ats_data + company_data
      end
    end

    puts "Finished getting jobs.\n"
    puts "Writing to storage..."
    puts "Saved #{jobs_data.size} job descriptions to database."
    write_to_storage(jobs_data)
  end

  private

  def build_unique_jobs
    Job.includes(:company).map do |job|
      [job.company.ats_identifier, job.job_title, job.non_geocoded_location_string]
    end
  end

  def write_to_storage(data)
    filepath = 'storage/relevant_jobs.csv'
    CSV.open(filepath, "wb") do |csv|
      # csv << ['Company ID', 'Job Title', 'Job Description', 'Inferred Seniority']
      data.each do |line|
        csv << line
      end
    end
  end
end
