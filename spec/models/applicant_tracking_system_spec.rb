require 'rails_helper'
require 'support/spec_constants'

# rubocop:disable Metrics/BlockLength
RSpec.describe ApplicantTrackingSystem, type: :model, ats: true do
  include CheckUrlIsValid

  describe 'Associations' do
    it { is_expected.to have_many(:companies) }
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context "With current modules", :vcr do
    before(:all) do
      Builders::AtsBuilder.new.build

      @ashbyhq = ApplicantTrackingSystem.find_by(name: 'AshbyHQ')
      @bamboohr = ApplicantTrackingSystem.find_by(name: 'BambooHR')
      @gh = ApplicantTrackingSystem.find_by(name: 'Greenhouse')
      @lever = ApplicantTrackingSystem.find_by(name: 'Lever')
      @manatal = ApplicantTrackingSystem.find_by(name: 'Manatal')
      @pinpointhq = ApplicantTrackingSystem.find_by(name: 'PinpointHQ')
      @recruitee = ApplicantTrackingSystem.find_by(name: 'Recruitee')
      @smartrecruiters = ApplicantTrackingSystem.find_by(name: 'SmartRecruiters')
      @workable = ApplicantTrackingSystem.find_by(name: 'Workable')
      @workday = ApplicantTrackingSystem.find_by(name: 'Workday')
      @devitjobs = ApplicantTrackingSystem.find_by(name: 'DevITJobs')
    end

    before(:each) do
      allow($stdout).to receive(:write) # suppresses terminal clutter
    end

    it 'can parse a url and determine the ATS' do
      bamboohr_url = 'https://avidbots.bamboohr.com/careers/789'
      ats = ApplicantTrackingSystem.determine_ats(bamboohr_url)
      expect(ats.name).to eq('BambooHR')

      tricky_url = 'https://apply.workable.com/reedsy/j/7205B30B16/?utm_source=DevITjobs&utm_medium=Job Board'
      ats = ApplicantTrackingSystem.determine_ats(tricky_url)
      expect(ats.name).to eq('Workable')
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

      workday_urls = %w[
        https://motorolasolutions.wd5.myworkdayjobs.com/en-US/Careers/details/UI-Designer_R45335
        https://motorolasolutions.wd5.myworkdayjobs.com/en-US/Careers/details/UI-Designer_R45335?locationCountry=29247e57dbaf46fb855b224e03170bc7
        https://motorolasolutions.wd5.myworkdayjobs.com/Careers/job/Glasgow-UK-ZUK118/UI-Designer_R45335
        https://motorolasolutions.wd5.myworkdayjobs.com/Careers/job/UI-Designer_R45335
        https://motorolasolutions.wd5.myworkdaysite.com/Careers/job/UI-Designer_R45335
      ]
      workday_urls.each do |workday_url|
        expect(@workday.parse_url(workday_url)).to eq(['motorolasolutions/Careers/5', 'UI-Designer_R45335'])
      end

      # TODO: Implement testing of DevITJobs
      # devitjobs_url = 'https://devitjobs.uk/jobs/Nesta-Frontend-Mid-Level-Developer'
      # expect(@devitjobs.parse_url(devitjobs_url)).to eq(['###', 'Nesta-Frontend-Mid-Level-Developer'])
    end

    it "neither throws an error when given a bad ats_identifier nor persists non-existent companies" do
      VCR.use_cassette('bad_company_data') do
        COMPANIES.each_key do |ats_name|
          puts "Trying #{ats_name}"
          ats = ApplicantTrackingSystem.find_by(name: ats_name)
          company = CompanyCreator.call(ats:, ats_identifier: 'zzzzz')
          expect(company.persisted?).to be_falsey
        end
      end
    end

    it 'can create a company with AshbyHQ' do
      VCR.use_cassette('create_company_ashbyhq') do
        CompanyCreator.call(ats: @ashbyhq, ats_identifier: 'lightdash')
        expect(Company.last.name).to eq('Lightdash')
      end
    end

    it 'can create a company with BambooHR' do
      VCR.use_cassette('create_company_bamboohr') do
        CompanyCreator.call(ats: @bamboohr, ats_identifier: 'avidbots')
        expect(Company.last.name).to eq('Avidbots')
      end
    end

    it 'can create a company with Greenhouse' do
      VCR.use_cassette('create_company_greenhouse') do
        CompanyCreator.call(ats: @gh, ats_identifier: 'codepath')
        expect(Company.last.name).to eq('CodePath')
      end
    end

    it 'can create a company with Lever' do
      VCR.use_cassette('create_company_lever') do
        CompanyCreator.call(ats: @lever, ats_identifier: 'GoToGroup')
        expect(Company.last.name).to eq('GoTo Group')
      end
    end

    it 'can create a company with Manatal' do
      VCR.use_cassette('create_company_manatal') do
        CompanyCreator.call(ats: @manatal, ats_identifier: 'ptc-group')
        expect(Company.last.name).to eq('PTC Group')
      end
    end

    it 'can create a company with PinpointHQ' do
      VCR.use_cassette('create_company_pinpointhq') do
        CompanyCreator.call(ats: @pinpointhq, ats_identifier: 'bathspa')
        expect(Company.last.name).to eq('Bath Spa University')
      end
    end

    it 'can create a company with Recruitee' do
      VCR.use_cassette('create_company_recruitee') do
        CompanyCreator.call(ats: @recruitee, ats_identifier: RECRUITEE_COMPANY.first)
        expect(Company.last.name).to eq(RECRUITEE_COMPANY.second)
      end
    end

    it 'can create a company with SmartRecruiters' do
      VCR.use_cassette('create_company_smartrecruiters') do
        CompanyCreator.call(ats: @smartrecruiters, ats_identifier: 'Gousto1')
        expect(Company.last.name).to eq('Gousto')
      end
    end

    # This test will route through proxy when API rate limit is reached
    it 'can create a company with Workable' do
      VCR.use_cassette('create_company_workable') do
        CompanyCreator.call(ats: @workable, ats_identifier: 'kroo')
        expect(Company.last.name).to eq('Kroo')
      end
    end

    it 'can create a company with Workday' do
      VCR.use_cassette('create_company_workday') do
        CompanyCreator.call(ats: @workday, ats_identifier: 'motorolasolutions/Careers/5')
        expect(Company.last.name).to eq('Motorola Solutions')
      end
    end

    # TODO: Implement testing of DevITJobs
    it 'can create a company with DevITJobs' do
      skip 'DevITJobs is not yet implemented'
      # VCR.use_cassette('create_company_devitjobs') do
      #   @devitjobs.find_or_create_company('Nesta')
      #   expect(Company.last.name).to eq('Frontend Mid Level Developer')
      # end
    end

    it 'can create a job with AshbyHQ' do
      VCR.use_cassette('create_job_ashbyhq') do
        url = "https://api.ashbyhq.com/posting-api/job-board/lightdash?includeCompensation=true"
        feed = get_json_data(url)
        title = feed.dig('jobs', 0, 'title')
        job_id = feed.dig('jobs', 0, 'id')
        company = CompanyCreator.call(ats: @ashbyhq, ats_identifier: 'lightdash')
        job = JobCreator.call(ats: @ashbyhq, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with BambooHR' do
      VCR.use_cassette('create_job_bamboohr') do
        url = "https://premise.bamboohr.com/careers/list"
        feed = get_json_data(url)
        title = feed.dig('result', 0, 'jobOpeningName')
        job_id = feed.dig('result', 0, 'id')
        company = CompanyCreator.call(ats: @bamboohr, ats_identifier: 'premise')
        job = JobCreator.call(ats: @bamboohr, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with Greenhouse' do
      VCR.use_cassette('create_job_greenhouse') do
        url = "https://boards-api.greenhouse.io/v1/boards/codepath/jobs/"
        feed = get_json_data(url)
        title = feed.dig('jobs', 0, 'title')
        job_id = feed.dig('jobs', 0, 'id')
        company = CompanyCreator.call(ats: @gh, ats_identifier: 'codepath')
        job = JobCreator.call(ats: @gh, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with Lever' do
      VCR.use_cassette('create_job_lever') do
        url = "https://api.lever.co/v0/postings/GoToGroup/?mode=json"
        feed = get_json_data(url)
        title = feed.dig(0, 'text')
        job_id = feed.dig(0, 'id')
        company = CompanyCreator.call(ats: @lever, ats_identifier: 'GoToGroup')
        job = JobCreator.call(ats: @lever, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with Manatal' do
      VCR.use_cassette('create_job_manatal') do
        url = "https://core.api.manatal.com/open/v3/career-page/ptc-group/jobs/"
        feed = get_json_data(url)
        title = feed.dig('results', 0, 'position_name')
        job_id = feed.dig('results', 0, 'hash')
        company = CompanyCreator.call(ats: @manatal, ats_identifier: 'ptc-group')
        job = JobCreator.call(ats: @manatal, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with PinpointHQ' do
      VCR.use_cassette('create_job_pinpointhq') do
        url = "https://bathspa.pinpointhq.com/postings.json"
        feed = get_json_data(url)
        title = feed.dig('data', 0, 'title')
        job_id = feed.dig('data', 0, 'path').sub('/en/postings/', '')
        company = CompanyCreator.call(ats: @pinpointhq, ats_identifier: 'bathspa')
        job = JobCreator.call(ats: @pinpointhq, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with Recruitee' do
      VCR.use_cassette('create_job_recruitee') do
        url = "https://#{RECRUITEE_COMPANY.first}.recruitee.com/api/offers/"
        feed = get_json_data(url)
        title = feed.dig('offers', 0, 'title')
        job_id = feed.dig('offers', 0, 'slug')
        company = CompanyCreator.call(ats: @recruitee, ats_identifier: RECRUITEE_COMPANY.first)
        job = JobCreator.call(ats: @recruitee, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with SmartRecruiters' do
      VCR.use_cassette('create_job_smartrecruiters') do
        url = "https://api.smartrecruiters.com/v1/companies/Gousto1/postings"
        feed = get_json_data(url)
        title = feed.dig('content', 0, 'name')
        job_id = feed.dig('content', 0, 'id')
        company = CompanyCreator.call(ats: @smartrecruiters, ats_identifier: 'Gousto1')
        job = JobCreator.call(ats: @smartrecruiters, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with Workable' do
      VCR.use_cassette('create_job_workable') do
        url = "https://apply.workable.com/api/v1/widget/accounts/#{WORKABLE_COMPANY.first}?details=true"
        feed = get_json_data(url)
        title = feed.dig('jobs', 0, 'title')
        job_id = feed.dig('jobs', 0, 'application_url').match(%r{https://apply\.workable\.com/j/(\w+)/apply})[1]
        company = CompanyCreator.call(ats: @workable, ats_identifier: WORKABLE_COMPANY.first)
        job = JobCreator.call(ats: @workable, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    it 'can create a job with Workday' do
      VCR.use_cassette('create_job_workday') do
        company_id = 'motorolasolutions/Careers/5'
        data = @workday.fetch_company_jobs(company_id, one_job_only: true)
        job_data = data['jobPostings']&.first
        title = job_data['title']
        job_id = job_data['externalPath'].split('/').last
        company = CompanyCreator.call(ats: @workday, ats_identifier: company_id)
        job = JobCreator.call(ats: @workday, company:, job_id:)
        expect(job.title).to eq(title)
      end
    end

    # TODO: Implement testing of DevITJobs
    it 'can create a job with DevITJobs' do
      skip 'DevITJobs is not yet implemented'
      # VCR.use_cassette('create_job_devitjobs') do
      #   expect(job.title).to eq(title)
      # end
    end
  end
end
# rubocop:enable Metrics/BlockLength
