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
      attach_resume # this shouldn't be necessary if the user is stubbed correctly
      complete_input_fields
      complete_textarea_fields
      complete_date_fields
      complete_select_fields
      complete_checkbox_fields
    end
  end

  def complete_checkbox_fields
    puts "Completing checkbox fields..."
    all('fieldset').each do |fieldset|
      options = fieldset.all('input[type="checkbox"]')
      options.sample.click
    end
  end

  def complete_date_fields
    puts "Completing datepicker fields..."
    all('input[type="date"]').each do |field|
      field.set('13/01/2024')
    end
  end

  def complete_input_fields
    puts "Completing input fields..."
    all('input', visible: true) { |i| i.value == '' }
      .reject { |field| %w[checkbox date email file submit].include?(field['type']) }
      .each { |field| set_value(field) }
  end

  def complete_select_fields
    puts "Completing select fields..."
    all('select').each do |field|
      standard_value = fetch_standard_attribute(field)
      next field.select(standard_value) if standard_value

      options = field.all('option')[1..] # ignore the null option
      random_option = options.sample
      field.select(random_option.text)
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

    user = FactoryBot.create(:user, admin: true)
    user.saved_jobs.create(job_id:)
    application_process = user.application_processes.create
    job_application = application_process.job_applications.create(job_id:, additional_info: { email: user.user_detail.email })

    [user, application_process, job_application]
  end

  def pause_for_review = sleep @sleep_time

  def resume_file = 'public/Obretetskiy_cv.pdf'

  def set_value(field)
    value = fetch_standard_attribute(field) || Faker::Color.color_name

    field.set(value)
  end

  # Shouldn't be necessary once Cheddar form is fully aligned with user_detail
  def fetch_standard_attribute(field)
    standard_attributes.each do |attribute|
      return send(:"user_#{attribute}") if field.sibling('label').text.downcase.include?(attribute)
    end
    nil
  end

  def standard_attributes = [
    'address',
    'city',
    'country',
    'zip'
  ]

  def submit_form
    puts "Submitting the form..."
    application_form.find('input[type="submit"]').click
    find('a', text: 'Submit your applications').click
  end

  def user_address = "#{@user.user_detail.address_first}, #{@user.user_detail.address_second}"

  def user_city = @user.user_detail.city

  def user_country = 'United Kingdom'

  def user_zip = @user.user_detail.post_code
end
