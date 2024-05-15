class UpdateExistingCompanyJobs < ApplicationJob
  include CompanyCsv

  # Why do we get all the job urls?
  # Wouldn't the best approach here be to create a csv with all the company data from the respective APIs
  # Then we can query the APIs based on that data?

  # TODO: Update so that we have 2 processes:
  # TODO: (1) for all the existing jobs on the site, we check whether those are still live (and delete if not)
  # TODO: (2) for all the existing companies on the site, we check whether they have new jobs (and add if so)

  # TODO: Update this so that it pulls the list of companies from the DB rather than the CSV

  def perform
    puts "Beginning jobs updater for companies already seeded to the DB..."

    # Compile a list of urls (unique ids) of jobs from last update that may no longer be live
    @job_urls_from_last_update = Job.all.to_set(&:posting_url)
    @company_ids = ats_list
    @invalid_company_ids = ats_hash

    fetch_jobs_and_companies
    mark_defunct_jobs
    update_lists
  end

  private

  def fetch_jobs_and_companies
    @company_ids.each do |ats_name, ats_identifiers|
      puts "Scanning #{ats_name} jobs:"
      @ats = ApplicantTrackingSystem.find_by(name: ats_name)

      ats_identifiers.each do |ats_identifier|
        puts "Looking at jobs with #{ats_identifier}..."

        # Find or create the company
        unless (company = @ats.find_or_create_company(ats_identifier))
          puts "Problem with #{ats_identifier}"
          add_to_invalid_ids(ats_name, ats_identifier)
          next
        end

        begin
          company_jobs = company.create_all_relevant_jobs
        rescue NoDataReturnedError => e
          puts e.message
          add_to_invalid_ids(ats_name, ats_identifier)
          next
        end

        # Cross each live job off the list
        company_jobs.each { |job| @job_urls_from_last_update.delete(job.posting_url) }
      end
    end
  end

  def mark_defunct_jobs
    puts "Marking jobs that are no longer live:"
    @job_urls_from_last_update.each do |posting_url|
      job = Job.find_by(posting_url:)
      job.live = false
      puts "No longer live: #{job.title}"
    end
  end

  def update_lists
    remove_invalid_ids_from_company_ids
    update_company_ids
    update_invalid_ids
  end

  def remove_invalid_ids_from_company_ids
    @invalid_company_ids.each do |ats_name, company_id|
      @company_ids[ats_name].delete(company_id)
    end
  end

  def update_company_ids
    save_ats_list(@company_ids)
  end

  def add_to_invalid_ids(ats_name, ats_identifier)
    puts "#{ats_identifier} is an invalid id for #{ats_name}"
    @invalid_company_ids[ats_name] << ats_identifier
  end

  def update_invalid_ids
    invalid_ids_from_last_update = load_from_csv('invalid_ids')
    @invalid_company_ids.merge!(invalid_ids_from_last_update) do |_k, new_set, old_set|
      new_set.merge(old_set)
    end
    save_ats_list(@invalid_company_ids, 'invalid_ids')
  end
end
