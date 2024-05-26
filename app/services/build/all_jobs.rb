module Build
  class AllJobs
    def build
      Company.all.each do |company|
        company.create_all_relevant_jobs
      rescue StandardError => e
        puts "Error: #{e}"
      end
    end
  end
end
