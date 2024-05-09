module NetZeroData
  class ZeroTrackerJob < ApplicationJob
    queue_as :default

    def perform
      NetZeroData::ZeroTracker.new.build_all_data
    end
  end
end
