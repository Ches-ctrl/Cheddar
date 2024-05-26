module Build
  class AllCompaniesJob < ApplicationJob
    queue_as :updates
    retry_on StandardError, attempts: 0

    def perform
      CompanyBuilder.new.build
    end

    def perform_companies_and_jobs
      CompanyBuilder.new.build
      # TODO: Move all builders into a single folder. This could call the service class and achieve the same thing
      Build::AllJobsJob.perform_later
    end
  end
end
