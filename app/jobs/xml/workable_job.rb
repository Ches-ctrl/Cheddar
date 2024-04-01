module Xml
  class WorkableJob < ApplicationJob
    queue_as :default

    def perform
      Xml::WorkableService.new.scrape_page
    end
  end
end
