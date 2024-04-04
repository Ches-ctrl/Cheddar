class CsvImporter
  def initialize file
    @file = file
  end

  def import!
    parsed = CSV.parse @file, headers: true

    parsed.map do |row|
      company = Company.find_or_create_by company_name: row["Company"]

      country = Country.find_or_create_by name: "United Kingdom"
      locations = create_locations(country, row["Location"])

      deadline = date_for(row["Deadline"])

      Job.create industry: row["Sector"],
                 job_title: row["Job Title"],
                 job_posting_url: row["Final ATS Url"],
                 application_deadline: deadline,
                 company:,
                 locations: locations,
                 job_description: row["Short Description"],
                 seniority: row["Job-Type"]
    end
  end

  private

  def date_for deadline_string
    Date.parse deadline_string unless deadline_string == "Rolling deadline"
  end

  def create_locations country, location_string
    return [Location.find_or_create_by(city: "Any", country: country)] if location_string == "United Kingdom"
    return [Location.find_or_create_by(city: location_string.split('-').last.strip, country: country)] if location_string.include? '-'

    if location_string.include? '|'
      return location_string.split('|').map(&:strip).map do |city_name|
        Location.find_or_create_by city: city_name, country: country
      end
    end

    [Location.find_or_create_by(city: location_string, country: country)]
  end
end
