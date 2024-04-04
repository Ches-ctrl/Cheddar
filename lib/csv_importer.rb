class CsvImporter
  def initialize file
    @file = file
  end

  def import!
    parsed = CSV.parse @file, headers: true

    parsed.map do |row|
      company = Company.find_or_create_by company_name: row["Company"]
      location = Location.find_or_create_by city: row["Location"]

      deadline = nil if row["Deadline"] == "Rolling deadline"
      deadline = Date.parse row["Deadline"] unless row["Deadline"] == "Rolling deadline"

      Job.create industry: row["Sector"],
                 job_title: row["Job Title"],
                 job_posting_url: row["Final ATS Url"],
                 application_deadline: deadline,
                 company:,
                 locations: [location],
                 job_description: row["Short Description"],
                 seniority: row["Job-Type"]
    end
  end
end
