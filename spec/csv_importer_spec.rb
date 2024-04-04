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

  it "imports a job" do
    csv_importer = CsvImporter.new single_job_with_rolling_deadline

    imported = csv_importer.import!

    expect(imported.size).to eq 1
    first_imported = imported.first
    expect(first_imported.industry).to eq "Financial Consulting"
    expect(first_imported.job_title).to eq "Graduate Consulting Programme London August 2024"
    expect(first_imported.job_posting_url).to eq "https://brandfinance.com/careers/graduate-consulting-programme"
    expect(first_imported.application_deadline).to be_nil
    expect(first_imported.company.company_name).to eq "Brand Finance"
    expect(first_imported.locations.first.city).to eq "London"
    expect(first_imported.job_description).to start_with "Our graduate program offers professional"
    expect(first_imported.seniority).to eq "Grad"
  end

  context "deadlines" do
    it "has a deadline with no year" do
      csv_importer = CsvImporter.new single_job_with_deadline
      imported = csv_importer.import!

      expect(imported.first.application_deadline).to eq Date.new(2024, 3, 19)
    end

    it "treats a rolling deadline as nil"
  end

  it "handles 'United Kingdom' as location" do
    csv_importer = CsvImporter.new single_job_with_no_city
    imported = csv_import.import!

    expect(imported.first.locations.first.city).to eq "Any"
    expect(imported.first.locations.first.city).to eq "United Kingdom"
  end

  it "handles date with no year"
  it "handles multiple locations"
  it "knows that the country is always UK"
  it "handles when there is a division name in the location ie: 'Sureserve Group - Bathgate'"

  # Financial Consulting
  # Graduate Consulting Programme London August 2024
  # https://brandfinance.com/careers/graduate-consulting-programme
  # Rolling deadline
  # Brand Finance
  # London
  # "Our graduate program offers professional qualifications varied experience across client projects and rapid exposure to senior clients at major blue-chip organizations across the world. Are you a sel…"
  # Grad
end
