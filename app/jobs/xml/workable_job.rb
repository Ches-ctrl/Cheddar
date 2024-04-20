module Xml
  class WorkableJob < ApplicationJob
    queue_as :default

    def perform
      Xml::WorkableService.new.import_xml
    end
  end
end
