# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "CsvImporter" do
  let(:single_job_with_rolling_deadline) {
    %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Graduate Consulting Programme London August 2024,https://brandfinance.com/careers/graduate-consulting-programme,Rolling deadline,Brand Finance,London,"Our graduate program offers professional qualifications, varied experience across client projects and rapid exposure to senior clients at major blue-chip organizations across the world. Are you a sel…",Grad
)
  }

  let(:single_job_with_deadline) {
    %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Part-Qualified Actuarial Trainee Consultant (Risk Transfer) 2024,https://hymans.current-vacancies.com/Jobs/Advert/3033099?cid=2054&t=Actuarial-Trainee-Consultant--Risk-Transfer-,19 Mar,Hymans Robertson,Birmingham | Edinburgh | Glasgow | London,As a part-qualified actuarial trainee you will be supporting a portfolio of client accounts manage their risks as part of our de-risking team providing high quality advice to support de-risking strat…,Grad
)
  }

  def import string
    CsvImporter.new(string).import!
  end

  it "imports a job" do
    imported = import single_job_with_rolling_deadline

    expect(imported.size).to eq 1
    first_imported = imported.first
    expect(first_imported.industry).to eq "Financial Consulting"
    expect(first_imported.job_title).to eq "Graduate Consulting Programme London August 2024"
    expect(first_imported.job_posting_url).to eq "https://brandfinance.com/careers/graduate-consulting-programme"
    expect(first_imported.application_deadline).to be_nil
    expect(first_imported.company.company_name).to eq "Brand Finance"
    expect(first_imported.locations.first.city).to eq "London"
    expect(first_imported.locations.first.country.name).to eq "United Kingdom"
    expect(first_imported.job_description).to start_with "Our graduate program offers professional"
    expect(first_imported.seniority).to eq "Grad"
  end

  context "deadlines" do
    it "has a deadline with no year" do
      imported = import single_job_with_deadline

      expect(imported.first.application_deadline).to eq Date.new(2024, 3, 19)
    end

    it "treats a rolling deadline as nil"
  end

  context "locations" do
    let(:single_job_with_no_city) {
      %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Tax Consulting Graduate Scheme 2024,https://www2.deloitte.com/uk/en/pages/careers/articles/early-careers-tax-consulting.html?nc=42&utm_source=bright-network&utm_medium=click-tracker&utm_campaign=deloitte-ecr-fy24&utm_term=smrs&utm_content=169328-think-prospecting-1x1-ftg-job-listings-tax-consulting&dclid=CPDF9cHitYQDFf6lZgId2cYOUg,Rolling deadline,Deloitte,United Kingdom,"Our purpose is to make an impact that matters by creating trust and confidence in a more equitable society. We do so by using our vast range of expertise, that covers audit, risk advisory, and...",Grad
)
    }

    let(:single_job_with_multiple_locations) {
      %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Part-Qualified Actuarial Trainee Consultant (Risk Transfer) 2024,https://hymans.current-vacancies.com/Jobs/Advert/3033099?cid=2054&t=Actuarial-Trainee-Consultant--Risk-Transfer-,19 Mar,Hymans Robertson,Birmingham | Edinburgh | Glasgow | London,As a part-qualified actuarial trainee you will be supporting a portfolio of client accounts manage their risks as part of our de-risking team providing high quality advice to support de-risking strat…,Grad
)
    }

    let(:single_job_with_division_in_location) {
      %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Energy,Energy & Environmental Excellence Graduate Bathgate 2024,https://careers.sureservegroup.co.uk/jobs/3513134-energy-environmental-excellence-graduate?ittk=DGAAXNROQF,Rolling deadline,Canopius,Sureserve Group - Bathgate,"The Energy and Environmental Excellence Graduate is a new role risen to support the Operations Manager and Operations Director in key projects, spanning across various focus areas including investmen…",Grad
)
    }

    it "handles 'United Kingdom' as location" do
      first_location = import(single_job_with_no_city).first.locations.first

      expect(first_location.city).to eq "Any"
      expect(first_location.country.name).to eq "United Kingdom"
    end

    it "handles multiple locations" do
      first_imported = import(single_job_with_multiple_locations).first

      location_cities = first_imported.locations.map { |location| location.city }

      expect(first_imported.locations.count).to eq location_cities.size
      location_cities.each do |city_name|
        expect(first_imported.locations.where(city: city_name).count).to eq 1
      end
    end

    it "handles when there is a division name in the location ie: 'Sureserve Group - Bathgate'" do
      first_imported = import(single_job_with_division_in_location).first

      expect(first_imported.locations.first.city).to eq "Bathgate"
    end
  end
end