module Importer
  module Scraper
    class TrueUpJob < ApplicationJob
      def perform
        Importer::Scraper::TrueUp.new.perform
      end
    end
  end
end
