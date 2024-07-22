module Ats
  module Workday
    module ApplicationFields
      def get_application_question_set(job, _data)
        p "Getting Workday application criteria"

        # TODO : implement new application_question_structure structure
        # job.build_application_question_set = {} # TODO: fix this
        job.save
      end
    end
  end
end
