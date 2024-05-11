class CompanyBuilder
  attr_reader :ats_identifiers_csv

  def initialize(ats_identifiers_csv)
    @ats_identifiers_csv = ats_identifiers_csv
  end

  def build
    CSV.foreach(@ats_identifiers_csv, headers: true) do |row|
      ats_name = row["ats_name"]
      ats_identifier = row["ats_identifier"]
      ats = ApplicantTrackingSystem.find_by(name: ats_name)

      company = ats.find_or_create_company(ats_identifier)

      if company
        puts "Created Company - #{company.name}"
      else
        p "Error creating Company - #{ats_identifier}"
      end
    end
  end
end
