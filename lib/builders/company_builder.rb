module Builders
  class CompanyBuilder
    attr_reader :ats_identifiers_csv

    def initialize
      @ats_identifiers_csv = 'storage/csv/ats_identifiers.csv'
    end

    def build
      CSV.foreach(@ats_identifiers_csv, headers: true) do |row|
        ats_name = row["ats_name"]
        ats_identifier = row["ats_identifier"]
        ats = ApplicantTrackingSystem.find_by(name: ats_name)

        unless ats
          puts "Error: Applicant Tracking System '#{ats_name}' not found."
          next
        end

        company = CompanyCreator.call(ats:, ats_identifier:)

        if company
          puts "Created Company - #{company.name}"
        else
          p "Error creating Company - #{ats_identifier}"
        end
      rescue StandardError => e
        puts "Error: #{e}"
      end
    end
  end
end
