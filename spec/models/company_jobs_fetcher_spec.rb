require Rails.root.join('spec', 'support', 'spec_constants.rb')

RSpec.describe CompanyJobsFetcher do
  context "with an existing company" do
    before do
      # allow($stdout).to receive(:write) # suppresses terminal clutter

      Builders::AtsBuilder.new.build
    end

    COMPANIES.each do |ats_name, ats_id|
      it "can create all relevant jobs with #{ats_name}", :vcr do
        VCR.use_cassette("fetch_company_jobs_#{ats_name}") do
          ats = ApplicantTrackingSystem.find_by(name: ats_name)
          company = CompanyCreator.call(ats:, ats_identifier: ats_id)
          unless company.persisted?
            data = ats.fetch_company_jobs(ats_id)&.first
            company = CompanyCreator.call(ats:, data:)
          end

          jobs = CompanyJobsFetcher.new(company).call

          expect(jobs).to be_an(Array)
          expect(jobs.first).to be_a(Job) if jobs.present?
        end
      end
    end
  end
end
