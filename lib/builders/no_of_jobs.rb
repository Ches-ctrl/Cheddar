module Builders
  class NoOfJobs
    include Constants::Files

    # TODO: Very basic implementation at the moment - needs to handle jobs boards, company sites, non-valid urls etc.
    # TODO: Add other csv files to the list

    def initialize
      @job_count = Hash.new(0)
      @counter = 0
    end

    # Analyzes CSV files to count jobs by Applicant Tracking System (ATS)
    def analyse
      FILES.each do |file|
        process_file(file)
      end

      sorted_job_count = @job_count.sort_by { |_ats, count| -count }
      write_to_csv(sorted_job_count)

      puts "Total number of jobs: #{@job_count.values.sum}"
    end

    private

    # Processes a single CSV file
    def process_file(file)
      CSV.foreach("storage/new/#{file}", headers: true) do |row|
        @counter += 1
        process_row(row)
      end
    rescue StandardError => e
      puts "Error processing file #{file}: #{e.message}"
    end

    # Processes a single row from a CSV file
    def process_row(row)
      url = row['posting_url']
      return unless url

      ats = determine_ats(url)
      @job_count[ats] += 1 if ats
    rescue StandardError => e
      puts "Error processing row: #{e.message}"
    end

    # Determines the ATS from the URL
    def determine_ats(url)
      ApplicantTrackingSystem.determine_ats(url).name
    rescue StandardError => e
      puts "Error determining ATS for URL #{url}: #{e.message}"
      nil
    end

    # Writes the job count to a CSV file
    def write_to_csv(sorted_job_count)
      CSV.open('storage/analysis/no_of_jobs_by_ats.csv', 'w') do |csv|
        csv << ['ATS', 'Number of Jobs']
        csv << ['Total', @counter]
        sorted_job_count.each do |ats, count|
          csv << [ats, count]
        end
      end
    rescue StandardError => e
      puts "Error writing to CSV: #{e.message}"
    end
  end
end
