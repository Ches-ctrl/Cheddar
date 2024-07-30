module Ats
  module Bamboohr
    module ApplicationFields
      def get_application_question_set(job, data)
        Importer::GetBambooFields.call(job, data)
      end
    end
  end
end
