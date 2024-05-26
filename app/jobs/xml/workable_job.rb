module Xml
  class WorkableJob < ApplicationJob
    queue_as :default
    retry_on StandardError, attempts: 0

    def perform
      Xml::Workable.new.import_xml
    end
  end
end
