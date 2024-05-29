module Builders
  class NoOfJobs
    include Constants::Files
    # TODO: Very basic implementation at the moment - needs to handle jobs boards, company sites, non-valid urls etc.
    # TODO: Add other csv files to the list

    def initialiaze
      @job_count = Hash.new(0)
      @counter = 0
    end

    def analyse
      FILES.each do |file|
        CSV.foreach("storage/new/#{file}", headers: true) do |row|
          @counter += 1

          begin
            url = row['posting_url']
            p url
            ats = ApplicantTrackingSystem.determine_ats(url).name if url
            ats_jobs_count[ats] += 1 if ats
          rescue StandardError => e
            puts "Error occurred: #{e.message}"
            next
          end
        end
      end

      sorted_job_count = @job_count.sort_by { |_ats, count| -count }
      write_to_csv(sorted_job_count)

      puts "Total number of jobs: #{@job_count.values.sum}"
    end

    def write_to_csv(sorted_job_count)
      CSV.open('storage/analysis/no_of_jobs_by_ats.csv', 'w') do |csv|
        csv << ['ATS', 'Number of Jobs']
        csv << ['Total', @counter]
        sorted_job_count.each do |ats, count|
          csv << [ats, count]
        end
      end
    end
  end
end
