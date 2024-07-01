# frozen_string_literal: true

module ApiFormatTranslators
  class WorkableAtsTranslator < BaseAtsTranslator
    def translate
      @parsed_data.transform_keys!(&:upcase)
      @parsed_data.merge!({ full_name: })
      @parsed_data.to_json
    end

    def full_name
      "#{@parsed_data['CA_18008']}_#{@parsed_data['CA_18009']}"
    end
  end
end
