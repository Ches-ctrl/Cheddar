module Ats
  module Bamboohr
    module ApplicationFields
      def get_application_question_set(_job, data)
        formatted_data = Importer::BamboohrFieldsFormatter.call(data.with_indifferent_access)
        Importer::FieldsBuilder.call(formatted_data)
      end
    end
  end
end
