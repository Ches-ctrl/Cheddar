module Build
  class AllJobs < ApplicationJob
    queue_as :updates

    def perform
      Company.all.each(&:create_all_relevant_jobs)
    end
  end
end
