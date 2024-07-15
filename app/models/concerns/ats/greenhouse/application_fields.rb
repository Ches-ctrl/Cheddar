module Ats
  module Greenhouse
    module ApplicationFields
      def get_application_criteria(job, _data)
        job.application_criteria = Importer::GetGreenhouseApiFields.call(job)
      end
    end
  end
end
