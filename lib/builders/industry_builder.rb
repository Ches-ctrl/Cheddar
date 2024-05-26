module Builders
  class IndustryBuilder
    attr_reader :industry_csv

    def initialize(industry_csv)
      @industry_csv = industry_csv
    end

    def build
      # TODO: Finalise industry and sub_industries we want to support
      # TODO: Separate out industry and sub_industry into separate models
      # NB. At the moment this won't work as the models don't yet exist

      CSV.foreach(@industry_csv, headers: true) do |row|
        industry = row["Industry"]
        sub_industry = row["Sub-Industry"]

        industry = Industry.find_or_create_by(name: industry)
        sub_industry = SubIndustry.find_or_create_by(name: sub_industry, industry:)

        if industry && sub_industry
          p "Created or found Industry - #{industry.name} with Sub-Industry - #{sub_industry.name}"
        else
          p "Error creating Industry or Sub-Industry - #{row['Industry']} - #{row['Sub-Industry']}"
        end
      end
    end
  end
end
