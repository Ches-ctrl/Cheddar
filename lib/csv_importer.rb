class CsvImporter
  def initialize file
    @file = file
  end

  def import!
    parsed = CSV.parse @file, headers: true

    parsed.map do |row|
      company = Company.find_or_create_by company_name: row["Company"]

      country = Country.find_or_create_by name: "United Kingdom"
      locations = create_locations(country, row)

      deadline = date_for(row)

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

  def date_for row
    Date.parse row["Deadline"] unless row["Deadline"] == "Rolling deadline"
  end

  def create_locations country, row
    if row["Location"] == "United Kingdom"
      [Location.find_or_create_by(city: "Any", country: country)]
    elsif row["Location"].include? '|'
      city_names = row["Location"].split('|').map(&:strip)

      city_names.map do |city_name|
        Location.find_or_create_by city: city_name, country: country
      end
    elsif row["Location"].include? '-'
      city_name = row["Location"].split('-').last.strip

      [Location.find_or_create_by(city: city_name, country: country)]
    else
      [Location.find_or_create_by(city: row["Location"], country: country)]
    end
  end
end
