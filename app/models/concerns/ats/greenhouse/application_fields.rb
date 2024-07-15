module Ats
  module Greenhouse
    module ApplicationFields
      def get_application_criteria(_job, data)
        Importer::GetGreenhouseFields.call(data)
      end
    end
  end
end
