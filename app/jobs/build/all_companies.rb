module Build
  class AllCompanies < ApplicationJob
    queue_as :updates

    def perform
      CompanyBuilder.new.perform
    end
  end
end
