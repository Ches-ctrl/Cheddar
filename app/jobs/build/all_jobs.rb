module Build
  class AllJobs < ApplicationJob
    queue_as :updates

    def perform
      Build::AllJobs.new.perform
    end
  end
end
