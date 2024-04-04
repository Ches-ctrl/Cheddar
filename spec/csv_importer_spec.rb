# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "CsvImporter" do
  mapping = {
    "Sector" => :industry,
    "Job Title" => :job_title,
    "Final ATS Url" => :job_posting_url,
    "Deadline" => :application_deadline,
    "Company" => "", # belongs_to :company,
    "Location" => "", # has_many :locations, through: :jobs_locations,
    "Short Description" => :job_description,
    "Job-Type" => :seniority
  }

  SINGLE_JOB_INPUT = %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Graduate Consulting Programme London August 2024,https://brandfinance.com/careers/graduate-consulting-programme,Rolling deadline,Brand Finance,London,"Our graduate program offers professional qualifications, varied experience across client projects and rapid exposure to senior clients at major blue-chip organizations across the world. Are you a sel…",Grad
)

  it "imports a job" do
    csv_importer = CsvImporter.new SINGLE_JOB_INPUT

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
    it "treats a rolling deadline as nil"

    it "has a deadline with no year" do
      JOB_WITH_DEADLINE_INPUT = %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Part-Qualified Actuarial Trainee Consultant (Risk Transfer) 2024,https://hymans.current-vacancies.com/Jobs/Advert/3033099?cid=2054&t=Actuarial-Trainee-Consultant--Risk-Transfer-,19 Mar,Hymans Robertson,Birmingham | Edinburgh | Glasgow | London,As a part-qualified actuarial trainee you will be supporting a portfolio of client accounts manage their risks as part of our de-risking team providing high quality advice to support de-risking strat…,Grad
)

      csv_importer = CsvImporter.new JOB_WITH_DEADLINE_INPUT
      imported = csv_importer.import!

      expect(imported.first.application_deadline).to eq Date.new(2024, 3, 19)
    end
  end

  it "handles actual deadline" do
    JOB_WITH_NO_DEADLINE_INPUT = %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Financial Operations Analyst Newcastle 2023,https://sagehr.my.salesforce-sites.com/careers/fRecruit__ApplyJob?vacancyNo=VN25987,Rolling deadline,Sage,Newcastle upon Tyne,"As a Financial Operations Analyst, this role offers an exciting array of opportunities for your professional growth and development. By working closely with both the P2P and O2C Teams, you will gain …",Grad
)

    csv_importer = CsvImporter.new JOB_WITH_NO_DEADLINE_INPUT
    imported = csv_importer.import!

    expect(imported.first.application_deadline).to eq nil
  end

  it "handles date with no year"
  it "handles multiple locations"
  it "knows that the country is always UK" do
    JOB_WITH_NO_DEADLINE_INPUT = %Q(Sector,Job Title,Final ATS Url,Deadline,Company,Location,Short Description,Job-Type
Financial Consulting,Financial Operations Analyst Newcastle 2023,https://sagehr.my.salesforce-sites.com/careers/fRecruit__ApplyJob?vacancyNo=VN25987,Rolling deadline,Sage,Newcastle upon Tyne,"As a Financial Operations Analyst, this role offers an exciting array of opportunities for your professional growth and development. By working closely with both the P2P and O2C Teams, you will gain …",Grad
)
  end

  it "handles 'United Kingdom' as location"
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
