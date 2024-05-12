module Build
  class AllJobs
    def perform
      Company.all.each(&:create_all_relevant_jobs)
    rescue StandardError => e
      puts "Error: #{e}"
    end
  end
end
