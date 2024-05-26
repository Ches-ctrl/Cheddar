module Build
  class AllJobs
    def build
      # TODO: Refactor into JobBuilder class matching CompanyBuilder and AtsBuilder
      Company.all.each do |company|
        company.create_all_relevant_jobs
      rescue StandardError => e
        puts "Error: #{e}"
      end
    end
  end
end
