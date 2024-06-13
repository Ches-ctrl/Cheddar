require 'rails_helper'
require 'faker'

RSpec.describe Updater::ExistingCompanyJobsService do
  ats_name = Faker::Ancient.titan
  company_id = Faker::Ancient.hero
  let(:existing_job_title) { Faker::JapaneseMedia::CowboyBebop.song }
  let(:job_posting_url) { Faker::Internet.url }
  let(:instance) { Updater::ExistingCompanyJobsService.new }
  mock_data = {
    ats_name => [company_id].to_set
  }

  before do
    allow($stdout).to receive(:write) # suppresses terminal clutter
    allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:ats_list).and_return(mock_data)
    # this next line is important to prevent csv data from being wiped:
    allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:save_ats_list).and_return(true)
  end

  describe '#call' do
    before do
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:fetch_jobs_and_companies) do |instance, _args|
        @existing_job_urls = instance.instance_variable_get(:@job_urls_from_last_update)
        @company_ids = instance.instance_variable_get(:@company_ids)
        @invalid_ids = instance.instance_variable_get(:@invalid_company_ids)
      end
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:mark_defunct_jobs).and_return(true)
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:update_lists).and_return(true)
    end

    it 'creates a set of all existing job urls' do
      create(:job, title: existing_job_title, posting_url: job_posting_url)
      instance.call
      expect(@existing_job_urls).to be_a(Set)
      expect(@existing_job_urls).to eq([job_posting_url].to_set)
    end

    it 'loads a list of companies to check for updates' do
      instance.call
      expect(@company_ids).to be_a(Hash)
      expect(@company_ids).to eq(mock_data)
    end

    it 'loads the existing list of invalid ids so as to avoid checking them' do
      instance.call
      expect(@invalid_ids).to be_a(Hash)
    end
  end

  describe '#fetch_jobs_and_companies' do
    before do
      ats = create(:applicant_tracking_system, name: ats_name)
      create(:company,
        ats_identifier: company_id,
        applicant_tracking_system: ats
      )
      allow_any_instance_of(Company).to receive(:create_all_relevant_jobs).and_return([])
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:mark_defunct_jobs).and_return(true)
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:update_lists).and_return(true)
    end

    it 'scans each company and ATS on the list' do
      expect { instance.call }.to output(include("Scanning #{ats_name} jobs:")).to_stdout
      expect { instance.call }.to output(include("Looking at jobs with #{company_id}...")).to_stdout
    end

    it 'marks any company_ids that are invalid' do
      returned_ats_name = nil
      returned_company_id = nil
      allow_any_instance_of(ApplicantTrackingSystem).to receive(:find_or_create_company).and_return(nil)
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:add_to_invalid_ids) do |_instance, *args|
        returned_ats_name, returned_company_id = args
      end
      instance.call
      expect(returned_ats_name).to eq(ats_name)
      expect(returned_company_id).to eq(company_id)
    end

    it "crosses off each job url that's still valid" do
      valid_job = create(:job, posting_url: job_posting_url)
      invalid_job = create(:job, posting_url: 'https://totally.does/not/exist')
      allow_any_instance_of(Company).to receive(:create_all_relevant_jobs).and_return([valid_job])
      instance.call
      expect(instance.instance_variable_get(:@job_urls_from_last_update)).to eq([invalid_job.posting_url].to_set)
    end
  end

  describe '#mark_defunct_jobs' do
    before do
      ats = create(:applicant_tracking_system, name: ats_name)
      create(:company,
        ats_identifier: company_id,
        applicant_tracking_system: ats
      )
      create(:job, title: existing_job_title)
      allow_any_instance_of(Company).to receive(:create_all_relevant_jobs).and_return([])
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:update_lists).and_return(true)
    end

    it 'marks jobs no longer in the ats feed as defunct' do
      instance.call
      job = Job.find_by(title: existing_job_title)

      expect(job.live).to be(false)
    end

    it "doesn't mark jobs still in the ats feed as defunct" do
      # ensure the job is crossed off the list once updated
      job = Job.find_by(title: existing_job_title)
      job.update(posting_url: job_posting_url)
      instance.call
      expect(job.live).to be(true)
    end
  end

  describe '#update_lists' do
    let(:invalid_list) {
      {
        ats_name => ['invalid_id'].to_set
      }
    }
    before do
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:fetch_jobs_and_companies).and_return(true)
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:mark_defunct_jobs).and_return(true)
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:update_company_ids).and_return(true)
    end

    it 'removes any company_ids marked as invalid from the list' do
      company_list = {
        ats_name => [company_id, 'invalid_id'].to_set
      }
      instance.instance_variable_set(:@company_ids, company_list)
      instance.instance_variable_set(:@invalid_company_ids, invalid_list)
      instance.send(:remove_invalid_ids_from_company_ids)
      returned_list = instance.instance_variable_get(:@company_ids)

      expect(returned_list[ats_name]).to eq([company_id].to_set)
    end

    it 'saves invalid ats_identifers to a csv' do
      previous_list = {
        ats_name => ['previous_id'].to_set
      }
      allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:load_from_csv).and_return(previous_list)
      instance.instance_variable_set(:@invalid_company_ids, invalid_list)
      instance.send(:update_invalid_ids)
      new_list = instance.instance_variable_get(:@invalid_company_ids)
      expect(new_list[ats_name].size).to eq(previous_list[ats_name].size + 1)
      expect(new_list[ats_name]).to include('invalid_id')
    end
  end

  # before do
  #   # allow($stdout).to receive(:write) # suppresses terminal clutter

  #   ats = create(:applicant_tracking_system, name: ats_name)
  #   create(:company,
  #     ats_identifier: company_id,
  #     applicant_tracking_system: ats
  #   )
  #   create(:job, title: existing_job_title)

  #   allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:ats_list).and_return(mock_data)
  #   # This next line is pretty important (avoids wiping existing csv files):
  #   allow_any_instance_of(Updater::ExistingCompanyJobsService).to receive(:save_ats_list) do |instance, *args|
  #     captured_arguments = args
  #     p instance
  #     p captured_arguments
  #     true
  #   end
  #   allow_any_instance_of(Company).to receive(:create_all_relevant_jobs).and_return([])
  #   @instance = Updater::ExistingCompanyJobsService.new
  # end

  # it 'loads a list of ats_identifiers' do
  #   expect { @instance.call }.to output(include("Scanning #{ats_name} jobs:")).to_stdout
  #   expect { @instance.call }.to output(include("Looking at jobs with #{company_id}...")).to_stdout
  # end

  # it 'identifies ats_identifiers that are invalid' do
  #   allow_any_instance_of(ApplicantTrackingSystem).to receive(:find_or_create_company).and_return(nil)

  #   expect { @instance.call }.to output(include("#{company_id} is an invalid id for #{ats_name}")).to_stdout
  # end

  # it 'saves invalid ats_identifers to a csv' do
  #   expect { @instance.call }.to output("mumble").to_stdout
  # end

  # it 'marks jobs no longer in the ats feed as defunct' do
  #   @instance.call
  #   job = Job.find_by(title: existing_job_title)
  #   expect(job.live).to be(false)
  # end

  # it "doesn't mark jobs still in the ats feed as defunct" do
  #   job = Job.find_by(title: existing_job_title)
  #   job.update(posting_url: job_posting_url)
  #   @instance.call
  #   expect(job.live).to be(true)
  # end
end
