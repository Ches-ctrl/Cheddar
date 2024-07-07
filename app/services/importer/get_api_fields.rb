module Importer
  # Core class for getting form fields directly from the API
  # Splits based on category of fields - main, custom, demographic, eeoc
  # Known Issues - XXX
  # Allowable file types (Greenhouse): (File types: pdf, doc, docx, txt, rtf)
  # NB. Must include all params to get additional fields from the API
  # Instructions:
  # 1.
  class GetApiFields < ApplicationTask
    include FaradayHelpers

    def initialize
      # @job = job
      # @url = @job.api_url
      @url = "https://boards-api.greenhouse.io/v1/boards/cleoai/jobs/4628944002"
      # @url = "https://boards-api.greenhouse.io/v1/boards/cleoai/jobs/7301308002"
      # @url = "https://boards-api.greenhouse.io/v1/boards/monzo/jobs/6076740"
      # @url = "https://boards-api.greenhouse.io/v1/boards/axios/jobs/6009256"
      # @url = "https://boards-api.greenhouse.io/v1/boards/11fs/jobs/4060453101"
      # @url = "https://boards-api.greenhouse.io/v1/boards/forter/jobs/7259821002"
      # @url = "https://boards-api.greenhouse.io/v1/boards/cleoai/jobs/4628944002"
      @url += "?questions=true&location_questions=true&demographic_questions=true&&compliance=true&pay_transparency=true"
      # @ats_sections = %w[main_fields custom_fields demographic_questions eeoc_fields data_compliance security_code_fields]
      @fields = {}
      @errors = false
    end

    def call
      return unless processable

      process
    rescue StandardError => e
      Rails.logger.error "Error running GetFormFields: #{e.message}"
      nil
    end

    private

    def processable
      @url # && @job
    end

    def process
      p "Hello from GetApiFields!"

      json = fetch_json(@url)
      return unless json

      @fields['main_fields'] = json['questions']
      @fields['demographic_questions'] = json['demographic_questions']
      @fields['location_questions'] = json['location_questions']
      @fields['data_compliance'] = json['data_compliance']

      puts pretty_generate(@fields)
      @fields
    end
  end
end
