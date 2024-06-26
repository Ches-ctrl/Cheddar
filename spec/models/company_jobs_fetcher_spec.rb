require 'rails_helper'
require Rails.root.join('spec', 'support', 'spec_constants.rb')

RSpec.describe CompanyJobsFetcher do
  context "with an existing company" do
    before do
      allow($stdout).to receive(:write) # suppresses terminal clutter

      Builders::AtsBuilder.new.build
    end

    COMPANIES.each do |ats_name, ats_id|
      it "can create all relevant jobs with #{ats_name}", :vcr do
        VCR.use_cassette("fetch_company_jobs_#{ats_name}") do
          ats = ApplicantTrackingSystem.find_by(name: ats_name)
          company = ats.find_or_create_company(ats_id)
          unless company.persisted?
            data = ats.fetch_company_jobs(ats_id)&.first
            company = ats.find_or_create_company_by_data(data)
          end

          output = StringIO.new
          $stdout = output

          CompanyJobsFetcher.new(company).call

          $stdout = STDOUT

          expect(output.string).to match(/Found or created \d+ new jobs with .+\./)
        end
      end
    end
  end
end
