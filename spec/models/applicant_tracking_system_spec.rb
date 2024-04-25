include CheckUrlIsValid

RSpec.describe ApplicantTrackingSystem, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:companies) }
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context "with the currently written modules" do
    before do
      allow($stdout).to receive(:write) # suppresses terminal clutter

      ats_csv = 'storage/csv/ats_systems.csv'
      AtsBuilder.new(ats_csv).build
      @ashbyhq = ApplicantTrackingSystem.find_by(name: 'AshbyHQ')
      @bamboohr = ApplicantTrackingSystem.find_by(name: 'BambooHR')
      @gh = ApplicantTrackingSystem.find_by(name: 'Greenhouse')
      @lever = ApplicantTrackingSystem.find_by(name: 'Lever')
      @manatal = ApplicantTrackingSystem.find_by(name: 'Manatal')
      @pinpointhq = ApplicantTrackingSystem.find_by(name: 'PinpointHQ')
      @recruitee = ApplicantTrackingSystem.find_by(name: 'Recruitee')
      @smartrecruiters = ApplicantTrackingSystem.find_by(name: 'SmartRecruiters')
      @workable = ApplicantTrackingSystem.find_by(name: 'Workable')
    end

    it 'can parse a url and determine the ATS' do
      bamboohr_url = 'https://avidbots.bamboohr.com/careers/789'
      ats = ApplicantTrackingSystem.determine_ats(bamboohr_url)
      expect(ats.name).to eq('BambooHR')
    end

    it 'can parse a url and return the ATS, company and job_id' do
      ashbyhq_url = 'https://jobs.ashbyhq.com/lightdash/309706bc-1081-48b6-89dc-f769bbe17e6d'
      expect(@ashbyhq.parse_url(ashbyhq_url)).to eq(['lightdash', '309706bc-1081-48b6-89dc-f769bbe17e6d'])

      bamboohr_url = 'https://avidbots.bamboohr.com/careers/789'
      expect(@bamboohr.parse_url(bamboohr_url)).to eq(['avidbots', '789'])

      gh_url = 'https://boards.greenhouse.io/codepath/jobs/4035988007'
      expect(@gh.parse_url(gh_url)).to eq(['codepath', '4035988007'])

      lever_url = 'https://jobs.lever.co/GoToGroup/6f5accda-9ba2-4cdb-8d3d-2e8fc5b08788'
      expect(@lever.parse_url(lever_url)).to eq(['GoToGroup', '6f5accda-9ba2-4cdb-8d3d-2e8fc5b08788'])

      manatal_url = 'https://www.careers-page.com/ptc-group/job/L57699YR'
      expect(@manatal.parse_url(manatal_url)).to eq(['ptc-group', 'L57699YR'])

      pinpointhq_url = 'https://bathspa.pinpointhq.com/en/postings/75e155e4-7fdc-47f5-a608-506776673252'
      expect(@pinpointhq.parse_url(pinpointhq_url)).to eq(['bathspa', '75e155e4-7fdc-47f5-a608-506776673252'])

      recruitee_url = 'https://midas.recruitee.com/o/digital-data'
      expect(@recruitee.parse_url(recruitee_url)).to eq(['midas', 'digital-data'])

      smartrecruiters_url = 'https://jobs.smartrecruiters.com/Gousto1/743999979517878-head-of-software-engineering'
      expect(@smartrecruiters.parse_url(smartrecruiters_url)).to eq(['Gousto1', '743999979517878'])

      workable_url = 'https://apply.workable.com/kroo/j/13AE03BA88/'
      expect(@workable.parse_url(workable_url)).to eq(['kroo', '13AE03BA88'])
    end

    it 'can create a company with each ATS' do
      @ashbyhq.find_or_create_company('lightdash')
      expect(Company.last.company_name).to eq('Lightdash')

      @bamboohr.find_or_create_company('avidbots')
      expect(Company.last.company_name).to eq('Avidbots')

      @gh.find_or_create_company('codepath')
      expect(Company.last.company_name).to eq('CodePath')

      @lever.find_or_create_company('GoToGroup')
      expect(Company.last.company_name).to eq('GoTo Group')

      @manatal.find_or_create_company('ptc-group')
      expect(Company.last.company_name).to eq('PTC Group')

      @pinpointhq.find_or_create_company('bathspa')
      expect(Company.last.company_name).to eq('Bath Spa University')

      @recruitee.find_or_create_company('midas')
      expect(Company.last.company_name).to eq('Midas')

      @smartrecruiters.find_or_create_company('Gousto1')
      expect(Company.last.company_name).to eq('Gousto')

      # This test runs into a Cloudflare rate-limiting firewall
      # @workable.find_or_create_company('kroo')
      # expect(Company.last.company_name).to eq('Kroo Bank Ltd')
    end

    it 'can create a job with AshbyHQ' do
      url = "https://api.ashbyhq.com/posting-api/job-board/lightdash?includeCompensation=true"
      feed = get_json_data(url)
      job_title = feed.dig('jobs', 0, 'title')
      job_id = feed.dig('jobs', 0, 'id')
      company = @ashbyhq.find_or_create_company('lightdash')
      job = @ashbyhq.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with BambooHR' do
      url = "https://premise.bamboohr.com/careers/list"
      feed = get_json_data(url)
      job_title = feed.dig('result', 0, 'jobOpeningName')
      job_id = feed.dig('result', 0, 'id')
      company = @bamboohr.find_or_create_company('premise')
      job = @bamboohr.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with Greenhouse' do
      url = "https://boards-api.greenhouse.io/v1/boards/codepath/jobs/"
      feed = get_json_data(url)
      job_title = feed.dig('jobs', 0, 'title')
      job_id = feed.dig('jobs', 0, 'id')
      company = @gh.find_or_create_company('codepath')
      job = @gh.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with Lever' do
      url = "https://api.lever.co/v0/postings/GoToGroup/?mode=json"
      feed = get_json_data(url)
      job_title = feed.dig(0, 'text')
      job_id = feed.dig(0, 'id')
      company = @lever.find_or_create_company('GoToGroup')
      job = @lever.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with Manatal' do
      url = "https://core.api.manatal.com/open/v3/career-page/ptc-group/jobs/"
      feed = get_json_data(url)
      job_title = feed.dig('results', 0, 'position_name')
      job_id = feed.dig('results', 0, 'hash')
      company = @manatal.find_or_create_company('ptc-group')
      job = @manatal.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with PinpointHQ' do
      url = "https://bathspa.pinpointhq.com/postings.json"
      feed = get_json_data(url)
      job_title = feed.dig('data', 0, 'title')
      job_id = feed.dig('data', 0, 'path').sub('/en/postings/', '')
      company = @pinpointhq.find_or_create_company('bathspa')
      job = @pinpointhq.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with Recruitee' do
      url = "https://midas.recruitee.com/api/offers/"
      feed = get_json_data(url)
      job_title = feed.dig('offers', 0, 'title')
      job_id = feed.dig('offers', 0, 'slug')
      company = @recruitee.find_or_create_company('midas')
      job = @recruitee.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end

    it 'can create a job with SmartRecruiters' do
      url = "https://api.smartrecruiters.com/v1/companies/Gousto1/postings"
      feed = get_json_data(url)
      job_title = feed.dig('content', 0, 'name')
      job_id = feed.dig('content', 0, 'id')
      company = @smartrecruiters.find_or_create_company('Gousto1')
      job = @smartrecruiters.find_or_create_job(company, job_id)
      expect(job.job_title).to eq(job_title)
    end
  end
end
