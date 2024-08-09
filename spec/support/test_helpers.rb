require 'faker'

module TestHelpers
  def application_form
    first('form', visible: true)
  end

  def attach_resume
    puts "Attaching resume..."
    first('input[type="file"]').attach_file(resume_file)
  end

  def complete_all_fields
    within application_form do
      attach_resume
      complete_input_fields
      complete_textarea_fields
      complete_select_fields
      complete_checkbox_fields
    end
    sleep @sleep_time # verify
  end

  def complete_checkbox_fields
    puts "Completing checkbox fields..."
    all('fieldset').each do |fieldset|
      options = fieldset.all('input[type="checkbox"]')
      options.sample.click
    end
  end

  def complete_input_fields
    puts "Completing input fields..."
    all('input', visible: true)
      .reject { |field| %w[checkbox email file submit].include?(field['type']) }
      .each { |field| field.set(Faker::Color.color_name) }
  end

  def complete_select_fields
    puts "Completing select fields..."
    all('select').each do |field|
      options = field.all('option')[1..] # ignore the null option
      random_option = options.sample
      field.select(random_option.text)
      # sleep 0.2 # avoid obstructing the next element
    end
  end

  def complete_textarea_fields
    puts "Completing textarea fields..."
    all('textarea').each do |field|
      field.set(Faker::Quotes::Chiquito.joke)
    end
  end

  # quiet mode
  def do_not_log(&block)
    allow($stdout).to receive(:write) # suppresses terminal clutter
    result = block.call
    allow($stdout).to receive(:write).and_call_original # resumes printing to terminal
    result
  end

  # seeds ATS to test db, creates job from url and returns job_id
  def initialize_job(url)
    puts 'Creating a new job...'
    do_not_log {
      Builders::AtsBuilder.new.build
      _, _, job = Url::CreateJobFromUrl.new(url).create_company_then_job
      job.id
    }
  end

  # With an existing job:
  # - creates an admin user
  # - begins an application_process with 1 job_application for user & job
  def initialize_user_and_job_application(job_id)
    puts 'Initiating application with admin user...'

    user = FactoryBot.create(:user, email: "admin@example.com", admin: true)
    user.saved_jobs.create(job_id:)
    application_process = user.application_processes.create
    job_application = application_process.job_applications.create(job_id:, additional_info: { email: user.user_detail.email })

    [user, application_process, job_application]
  end

  def resume_file = 'public/Obretetskiy_cv.pdf'

  def submit_form
    application_form.find('input[type="submit"]').click
    find('a', text: 'Submit your applications').click
    sleep @sleep_time # verify
  end
end
