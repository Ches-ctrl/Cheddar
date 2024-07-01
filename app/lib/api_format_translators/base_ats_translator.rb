# app/lib/api_format_translators/api_format_translator.rb
# frozen_string_literal: true

module ApiFormatTranslators
  class BaseAtsTranslator
    def initialize(job_application)
      @parsed_data = begin
        JSON.parse(get_data(job_application).to_json)
      rescue
        {}
      end
    end

    def self.create_translator(job_application)
      ats_name = job_application.job.applicant_tracking_system.name
      begin
        ApiFormatTranslators.const_get("#{ats_name}AtsTranslator").new(job_application)
      rescue
        nil
      end
    end

    private

    def get_data(job_application)
      job_application.additional_info.merge(job_application.application_process.frequent_asked_info)
    end
  end
end
