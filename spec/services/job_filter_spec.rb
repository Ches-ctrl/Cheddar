require 'rails_helper'

RSpec.describe JobFilter do
  before do
    @roles = create_list(:role, 5)
    @roles.each_cons(2) { |a, b| create(:job, roles: [a, b]) }
    @jobs = Job.all
  end

  it 'initializes with the correct parameters' do
    params = {
      posted: 'week',
      seniority: 'senior',
      location: 'remote',
      role: 'mobile',
      employment: 'full_time'
    }
    job_filter = JobFilter.new(params)
    expect(job_filter.instance_variable_get(:@params)).to eq(params)
    expect(job_filter.instance_variable_get(:@jobs)).to eq(@jobs)
  end

  it 'returns all jobs when no filters are applied' do
    params = { posted: 'any-time'}
    job_filter = JobFilter.new(params)
    expect(job_filter.filter_and_sort).to match_array(@jobs)
  end

  it 'correctly applies filters: posted' do
    params = {
      posted: 'week',
    }
    included_job = create(:job, date_posted: Date.today - 6.days)
    excluded_job = create(:job, date_posted: Date.today - 12.days)
    job_filter = JobFilter.new(params)

    expect(job_filter.filter_and_sort).to include(included_job)
    expect(job_filter.filter_and_sort).not_to include(excluded_job)
  end

  it 'correctly applies filters: seniority' do
    params = {
      posted: 'any-time',
      seniority: 'mid-level'
    }
    included_job = create(:job, seniority: 'Mid-Level')
    excluded_job = create(:job, seniority: 'Junior')
    job_filter = JobFilter.new(params)

    expect(job_filter.filter_and_sort).to include(included_job)
    expect(job_filter.filter_and_sort).not_to include(excluded_job)
  end

  it 'correctly applies filters: location' do
    city_name = Location.first.city
    params = {
      posted: "any-time",
      location: city_name.downcase
    }
    job_filter = JobFilter.new(params)
    expected_jobs = @jobs.left_joins(:locations).where(locations: { city: city_name })

    expect(job_filter.filter_and_sort.count).to eq(expected_jobs.count)
    expect(job_filter.filter_and_sort).to match_array(expected_jobs)
  end

  it 'correctly applies filters: role' do
    role = @roles.first.name
    params = {
      posted: "any-time",
      role:
    }
    job_filter = JobFilter.new(params)
    expected_jobs = @jobs.left_joins(:roles).where(roles: { name: @roles.first.name })

    expect(job_filter.filter_and_sort.count).to eq(expected_jobs.count)
    expect(job_filter.filter_and_sort).to match_array(expected_jobs)
  end

  it 'correctly applies filters: employment' do
    params = {
      posted: "any-time",
      employment: 'part_time'
    }
    included_job = create(:job, employment_type: 'Part-time')
    excluded_job = create(:job, employment_type: 'Permanent')
    job_filter = JobFilter.new(params)

    expect(job_filter.filter_and_sort).to include(included_job)
    expect(job_filter.filter_and_sort).not_to include(excluded_job)
  end

  it 'can handle multiple criteria per category' do
    first_role, second_role = @roles.first(2).map(&:name)
    string = "#{first_role} #{second_role}"
    params = {
      posted: "any-time",
      role: string
    }
    job_filter = JobFilter.new(params)
    expected_jobs = @jobs.joins(:roles)
                         .where(roles: { name: [first_role, second_role] })
                         .distinct
    filtered_jobs = job_filter.filter_and_sort.distinct
    expect(filtered_jobs.count).to eq(expected_jobs.count)
    expect(filtered_jobs).to match_array(expected_jobs)
  end

  it 'correctly applies multiple filters' do
    params = {
      posted: '3-days',
      employment: 'full_time'
    }
    included_job = create(:job, date_posted: Date.today - 2.days, employment_type: 'Full-time')
    excluded_job = create(:job, date_posted: Date.today - 2.days, employment_type: 'Permanent')

    job_filter = JobFilter.new(params)
    expect(job_filter.filter_and_sort).to include(included_job)
    expect(job_filter.filter_and_sort).not_to include(excluded_job)
  end

  it 'correctly applies a search query' do
    params = {
      posted: 'any-time',
      query: 'ruby developer'
    }
    included_job = create(:job, title: 'Full-time Senior Developer Who Knows Ruby Real Good')
    excluded_job = create(:job, title: 'Something something ruby sapphire emeralds')

    job_filter = JobFilter.new(params)
    expect(job_filter.filter_and_sort).to include(included_job)
    expect(job_filter.filter_and_sort).not_to include(excluded_job)
  end

  it 'can handle a query and filters at the same time' do
    included_job = @jobs.sample
    employment_type = included_job.employment_type
    excluded_jobs = Job.where.not(employment_type:)

    role = included_job.roles.first.name
    query = included_job.countries.first.name.downcase

    params = {
      posted: 'any-time',
      role:,
      employment: employment_type.downcase.gsub(/[ -]/, '_'),
      query:
    }

    job_filter = JobFilter.new(params)
    expect(job_filter.filter_and_sort).to include(included_job)
    expect(job_filter.filter_and_sort).not_to include(*excluded_jobs)
  end
end
