module Ats
  module Workday
    module ApplicationFields
      def get_application_criteria(job, _data)
        p "Getting Workday application criteria"
        job.application_criteria = {} # TODO: fix this
        job.save
      end
    end
  end
end
