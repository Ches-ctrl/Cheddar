RSpec.describe CategorySidebar do
  before do
    @roles = create_list(:role, 5)
    @roles.each do |role|
      create_list(:job, 3, roles: [role])
    end
    10.times do
      role = Role.all.sample
      job = Job.all.sample
      job.roles << role unless job.roles.include?(role)
    end
    @jobs = Job.all

    @selected_roles = Role.all.sample(2)
    params = {
      posted: 'any-time',
      role: "#{@selected_roles.first.name} #{@selected_roles.second.name}"
    }
    filtered_jobs = JobFilter.new(params).filter_and_sort
    @resources, @total_jobs = CategorySidebar.new(filtered_jobs, params).build
  end

  it 'gives the correct count of total jobs' do
    expected_count = @jobs.joins(:roles)
                          .where(roles: @selected_roles)
                          .distinct
                          .count
    expect(@total_jobs).to eq(expected_count)
  end

  it 'returns the correct resources hash' do
    expected_resource = @roles.map do |role|
      [
        'checkbox',
        role.name.gsub('-', ' '),
        role.name,
        @jobs.joins(:roles).where(roles: role).distinct.count,
        @selected_roles.include?(role)
      ]
    end
    expected_resource.sort_by! { |_, name, _, count, _| [-count, name] }

    expect(@resources['role']).to eq(expected_resource)
  end
end
