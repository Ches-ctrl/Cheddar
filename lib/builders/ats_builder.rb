module Builders
  class AtsBuilder
    attr_reader :ats_csv

    ATTRIBUTES = {
      url_identifier: row["url_identifier"],
      url_website: row["url_website"],
      url_linkedin: row["url_linkedin"],
      url_base: row["url_base"],
      url_api: row["url_api"],
      url_all_jobs: row["url_all_jobs"],
      url_xml: row["url_xml"],
      url_rss: row["url_rss"],
      login: row["login"]
    }

    def initialize
      @ats_csv = 'storage/csv/ats_systems.csv'
    end

    def build
      CSV.foreach(@ats_csv, headers: true) do |row|
        ats_name = row["ats_name"]
        ats = ApplicantTrackingSystem.find_or_create_by(name: ats_name)

        ats.update(ATTRIBUTES)

        if ats
          puts "Created ATS - #{ats.name}"
        else
          p "Error creating ATS - #{ats_name}"
        end
      end
      p "Created #{ApplicantTrackingSystem.count} ATS systems."
    end
  end
end
