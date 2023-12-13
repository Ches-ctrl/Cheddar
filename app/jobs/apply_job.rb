class ApplyJob < ApplicationJob
  queue_as :default
  DEFAULTS = {
    'first_name' => {
      'value' => "UserMissingFirst"
    },
    'last_name' => {
      'value' => "UserMissingLast"
    },
    'email' => {
      'value' => "usermissingemail@getcheddar.xyz"
    },
    'phone_number' => {
      'value' => "+447555555555"
    },
    'address_first' => {
      'value' => "99 Missing Drive"
    },
    'address_second' => {
      'value' => "Missingham"
    },
    'post_code' => {
      'value' => "M1 1MM"
    },
    'salary_expectation_text' => {
      'value' => "£30,000 - £40,000"
    },
    'right_to_work' => {
      'value' => /yes/i ## TODO
    },
    'salary_expectation_figure' => {
      'value' => 30000
    },
    'notice_period' => {
      'value' => 12
    },
    'preferred_pronoun_select' => {
      'value' => /he\/him/i ## TODO
    },
    'preferred_pronoun_text' => {
      'value' => 'N/A' ## TODO
    },
    'employee_referral' => {
      'value' => "no"
    },
    'city' => {
      'value' => 'London'
    },
    'address' => {
      'value' => '8 Hawksmoor Mews, E1 0DG, London, United Kingdom'
    },
    'linkedin_profile' => {
      'value' => "https://www.linkedin.com/in/ilya-obretetskiy-b5010b1b5/"
    },
    'personal_website' => {
      'value' => "https://www.ilya.com"
    },
    'require_visa?' => {
      'value' => 'No',
    },
    'heard_of_company?' => {
      'value' => /yes/i
    },
    'heard_from' => {
      'value' => 'Cheddar'
    }
  }

  # TODO: Separate application criteria into separate DB table that is then called and we search through dynamically
  # TODO: Add a callback option so that the user inputs all the information required for the job before submitting
  # TODO: Notify the user of the application steps so that they're kept in the loop
  # TODO: Default value of Prefer Not To Say

  def perform(job_application_id, user_id)
    # p Setting job and user variables
    job = JobApplication.find(job_application_id).job
    user = User.find(user_id)

    # p Filling in form with user details
    application_criteria = assign_values_to_form(job, user)

    # Reassigning application criteria to fields_to_fill
    fields_to_fill = application_criteria

    # p "Initializing FormFiller..."
    form_filler = FormFiller.new

    # Going to URL and filling out form
    form_filler.fill_out_form(job.job_posting_url, fields_to_fill, job_application_id)

    # Ending Capbybara session
    Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }

    # sleep 3
    p "You applied to #{job.job_title}!"
  end

  private

  def assign_values_to_form(job, user)
    p "Assigning values to form in assign_values_to_form method..."
    application_criteria = job.application_criteria
    p "Application criteria without values: #{application_criteria}"

    application_criteria.each do |key, value|
      if user.respond_to?(key) && user.send(key).present?
        # Update the hash with the user's value for this attribute
        p "Using USER value for #{key}"
        application_criteria[key]['value'] = user.send(key)
      elsif DEFAULTS.key?(key) && DEFAULTS[key].key?('value')
        p "Warning: User does not have a method or attribute '#{key}'"
        p "Using DEFAULT value instead"
        application_criteria[key]['value'] = DEFAULTS.dig(key, 'value')
      else
        p "Warning: Defaults does not have a method or attribute '#{key}'"
        p "Using NIL value instead"
        application_criteria[key]['value'] = nil
      end
    end
    p "Application criteria with values: #{application_criteria}"
    return application_criteria
  end
end
