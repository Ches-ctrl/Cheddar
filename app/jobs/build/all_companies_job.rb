module Build
  class AllCompaniesJob < ApplicationJob
    queue_as :updates
    retry_on StandardError, attempts: 0

    def perform
      Builders::CompanyBuilder.new.build
    end

    def perform_companies_and_jobs
      Builders::CompanyBuilder.new.build
      Builders::JobBuilder.new.build
    end
  end
end
