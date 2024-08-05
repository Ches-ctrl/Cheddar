module Ats
  module Workday
    module ApplicationFields
      def get_application_question_set(job, _data)
        p "Getting Workday application criteria"
        Importer::GetWorkdayFields.call(job.apply_url)
        # TODO : implement new application_question_structure structure
        []
      end
    end
  end
end
