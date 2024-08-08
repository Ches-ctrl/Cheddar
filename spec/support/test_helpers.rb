module TestHelpers
  def fill_inputs_with_hello
    all('input').each do |field|
      field.set("hello")
    end
  end

  def print_hello
    puts "hello world"
  end

  def initialize_job(url)
    Builders::AtsBuilder.new.build
    _, _, job = Url::CreateJobFromUrl.new(url).create_company_then_job
    job.id
  end

  def initialize_user_and_job_application(job_id)
    puts 'Creating a job and initiating application with admin user...'

    allow($stdout).to receive(:write) # suppresses terminal clutter

    user = FactoryBot.create(:user, email: "admin@example.com", admin: true)
    user.saved_jobs.create(job_id:)
    application_process = user.application_processes.create
    job_application = application_process.job_applications.create(job_id:, additional_info: { email: user.user_detail.email })

    allow($stdout).to receive(:write).and_call_original # resumes printing to terminal
    [user, application_process, job_application]
  end
end
