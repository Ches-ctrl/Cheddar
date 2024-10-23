module Importer
  module Xml
    class WorkableParserJob < ApplicationJob
      queue_as :default
      retry_on StandardError, attempts: 0

      def perform
        Importer::Xml::WorkableParser.new.import_jobs
      end
    end
  end
end
