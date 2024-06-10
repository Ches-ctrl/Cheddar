require 'rails_helper'

RSpec.describe JobFilter do
  before do
    @roles = create_list(:role, 5)
    @roles.each_cons(2) { |a, b| create(:job, roles: [a, b]) }
    @jobs = Job.all
  end

  it 'initializes with the correct parameters' do
    params = {
      "posted"=>"any-time",
      "seniority"=>"senior",
      "location"=>"remote",
      "role"=>"mobile"
    }
    scope = @jobs
    job_filter = JobFilter.new(params, scope)
    expect(job_filter.instance_variable_get(:@params)).to eq(params)
    expect(job_filter.instance_variable_get(:@jobs)).to eq(@jobs)
  end

  it 'returns all jobs when no filters are applied' do
    params = {
      "posted"=>"any-time"
    }
    job_filter = JobFilter.new(params, @jobs)
    expect(job_filter.instance_variable_get(:@jobs)).to eq(@jobs)
  end

  it 'correctly applies filters' do
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
    expect(job_filter.filter_and_sort.count).to eq(expected_jobs.count)
    expect(job_filter.filter_and_sort).to match_array(expected_jobs)
  end
end

# Test that filter_and_sort returns all jobs when no filters are applied.
# Test that filter_and_sort correctly applies filters.
# Test that filter_by_department filters jobs by department when department parameter is present.
# Test that filter_by_department does not filter jobs when department parameter is not present.
