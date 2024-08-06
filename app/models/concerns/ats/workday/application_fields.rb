module Ats
  module Workday
    module ApplicationFields
      def get_application_question_set(job, _data)
        # TODO: Hook up GetWorkdayFields to a formatter and return an application_question_set
        p "Getting Workday application criteria"
        Importer::GetWorkdayFields.call(job.apply_url) # This isn't hooked up to anything
        []
      end
    end
  end
end
