module Importer
  module Xml
    class WorkableJob < ApplicationJob
      queue_as :default
      retry_on StandardError, attempts: 5

      def perform
        Importer::Xml::Workable.new.import_xml
      rescue => e
        puts "Job failed with error: #{e.class.name}: #{e.message}. Retrying..."
        raise e
      end
    end
  end
end
