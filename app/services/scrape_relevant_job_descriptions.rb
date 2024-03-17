class ScrapeRelevantJobDescriptions
  include AtsRouter
  include HashBuilder

  def initialize
    @companies = build_ats_companies
    @descriptions = build_relevant_descriptions
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
