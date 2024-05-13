namespace :no_of_jobs do
  desc "Check number of jobs by ATS"
  task number_of_jobs: :environment do
    # TODO: Very basic implementation at the moment - needs to handle jobs boards, company sites, non-valid urls etc.
    # TODO: Add other csv files to the list

    ats_jobs_count = Hash.new(0)

    files = [
      'job_posting_urls.csv',
      '80k_job_posting_urls.csv',
      'BN_job_posting_urls.csv',
      'CO_job_posting_urls.csv',
      'GH_job_posting_urls.csv',
      'LU_job_posting_urls.csv',
      'PA1_job_posting_urls.csv',
      'PA2_job_posting_urls.csv',
      'UM_job_posting_urls.csv'
    ]

    counter = 0

    files.each do |file|
      CSV.foreach("storage/new/#{file}", headers: true) do |row|
        counter += 1
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

    sorted_ats_jobs_count = ats_jobs_count.sort_by { |_ats, count| -count }

    CSV.open('storage/analysis/no_of_jobs_by_ats.csv', 'w') do |csv|
      csv << ['ATS', 'Number of Jobs']
      csv << ['Total', counter]
      sorted_ats_jobs_count.each do |ats, count|
        csv << [ats, count]
      end
    end

    puts "Total number of jobs: #{ats_jobs_count.values.sum}"
  end
end
