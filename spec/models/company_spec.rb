COMPANIES = {
  'AshbyHQ' => 'lightdash',
  'BambooHR' => 'avidbots',
  'DevITJobs' => 'BAE-Systems',
  'Greenhouse' => 'codepath',
  'Lever' => 'GoToGroup',
  'Manatal' => 'ptc-group',
  'PinpointHQ' => 'bathspa',
  'Recruitee' => 'midas',
  'SmartRecruiters' => 'Gousto1',
  'Workable' => 'kroo',
}

RSpec.describe Company do
  describe 'Associations' do
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
    it { is_expected.to belong_to(:applicant_tracking_system).optional(true) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:ats_identifier) }
  end

  context "with an existing company" do
    before do
      allow($stdout).to receive(:write) # suppresses terminal clutter

      ats_csv = 'storage/csv/ats_systems.csv'
      AtsBuilder.new(ats_csv).build
    end

    COMPANIES.each do |ats_name, ats_id|
      it "can create all relevant jobs with #{ats_name}" do
        ats = ApplicantTrackingSystem.find_by(name: ats_name)
        company = ats.find_or_create_company(ats_id)
        unless company.persisted?
          data = ats.fetch_company_jobs(ats_id)&.first
          company = ats.find_or_create_company_by_data(data)
        end

        output = StringIO.new
        $stdout = output

        company.create_all_relevant_jobs

        $stdout = STDOUT

        expect(output.string).to match(/Created \d+ new jobs with .+\./)
      end
    end
  end
end
