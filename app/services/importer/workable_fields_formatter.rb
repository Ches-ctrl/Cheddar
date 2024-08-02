# frozen_string_literal: true

module Importer
  class WorkableFieldsFormatter < ApplicationTask
    def initialize(data)
      @data = data
    end

    def call
      return [] unless processable

      process
    end

    private

    def processable
      false
    end

    def process
      # All yours, JB!
    end
  end
end
