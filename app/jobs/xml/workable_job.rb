module Xml
  class Workable < ApplicationJob
    queue_as :default

    def perform
      Xml::WorkableService.new.scrape_page
    end
  end
end
