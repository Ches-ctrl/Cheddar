module Build
  class AllCompaniesJob < ApplicationJob
    queue_as :updates
    retry_on StandardError, attempts: 0

    def perform
      CompanyBuilder.new.build
    end
  end
end
