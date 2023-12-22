require 'nokogiri'

class GetFormFieldsJob < ApplicationJob
  include Capybara::DSL

  queue_as :default
  sidekiq_options retry: false

  # TODO: Add scrape of job description and other details to this background job (so that it all executes in one capybara session)
  # TODO: Potentially change to scraping all fields from the job posting
  # TODO: Add cv required based on this scrape
  # TODO: add test of filling out the form fields before job goes live

  def perform(url)
    visit(url)
    return if page.has_selector?('#flash_pending')
    find_apply_button.click rescue nil

    # page_html = page.html
    form = find('form', text: /apply|application/i)
    form_html = page.evaluate_script("arguments[0].outerHTML", form.native)
    nokogiri_form = Nokogiri::HTML.fragment(form_html)

    fields = nokogiri_form.css('#custom_fields')
    labels = fields.css('label')

    attributes = {}
    labels.each do |label|
      # Could do this based off of name of ID

      # TODO: Add ability to deal with boolean required fields. Input will have an asterisk in a span class in that case
      # TODO: Fix issue where additional core fields will be shown to the user even if not required when included in the core greenhouse set

      # Stripping text, downcasing and replacing spaces with underscores to act as primary keys

      label_text = label.xpath('descendant-or-self::text()[not(parent::select or parent::option or parent::ul or parent::label/input[@type="checkbox"])]').text.strip.downcase.gsub(" ", "_")

      required = label_text.include?("*") ? true : false
      label_text = label_text.split("*")[0]

      name = label_text # not perfect
      next if name == ""
      next if label.parent.name == 'label'

      attributes[name] = {
        interaction: :input
      }

      inputs = label.css('input', 'textarea').reject { |input| input['type'] == 'hidden' || !input['id'] }
      unless inputs.empty?
        # attributes[name][:locators] = inputs[0]['name']
        attributes[name][:locators] = inputs[0]['id']
      end

      checkbox_input = label.css('label:has(input[type="checkbox"])')
      unless checkbox_input.empty?
        attributes[name][:interaction] = :checkbox
        attributes[name][:locators] = name
        attributes[name][:options] = label.css('label:has(input[type="checkbox"])').map { |option| option.text.strip }
      end

      select_input = label.css('select')
      unless select_input.empty?
        attributes[name][:interaction] = :select
        attributes[name][:locators] = select_input[0]['id']
        attributes[name][:option] = 'option'
        attributes[name][:options] = label.css('option').map { |option| option.text.strip }
      end
    end

    Capybara.current_session.driver.quit

    extra_fields = attributes

    p extra_fields

    unless extra_fields.nil?
      job = Job.find_by(job_posting_url: url)
      job.application_criteria = job.application_criteria.merge(extra_fields)
      job.save
      p job.application_criteria
    end

    # TODO: Check that including this here doesn't cause issues
    return attributes
    # attributes.delete(attributes.keys.last)
  end

  private

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end
end

# {"first_name"=>{"interaction"=>"input", "locators"=>"first_name"},
#  "last_name"=>{"interaction"=>"input", "locators"=>"last_name"},
#  "email"=>{"interaction"=>"input", "locators"=>"email"},
#  "phone_number"=>{"interaction"=>"input", "locators"=>"phone"},
#  "resume"=>{"interaction"=>"upload", "locators"=>"button[aria-describedby=\"resume-allowable-file-types\""},
#  "city"=>{"interaction"=>"input", "locators"=>"job_application[location]"},
#  "location_click"=>{"interaction"=>"listbox", "locators"=>"ul#location_autocomplete-items-popup"},
#  "linkedin_profile"=>{"interaction"=>"input", "locators"=>"input[autocomplete=\"custom-question-linkedin-profile\"]"},
#  "personal_website"=>{"interaction"=>"input", "locators"=>"input[autocomplete=\"custom-question-website\"], input[autocomplete=\"custom-question-portfolio-linkwebsite\"]"},
#  "heard_from"=>{"interaction"=>"input", "locators"=>"input[autocomplete=\"custom-question-how-did-you-hear-about-this-job\"]"},
#  "require_visa?"=>{"interaction"=>"input", "locators"=>"textarea[autocomplete=\"custom-question-would-you-need-sponsorship-to-work-in-the-uk-\"]"},
#  "LinkedIn Profile"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_0_text_value"},
#  "Website"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_1_text_value"},
#  "How did you hear about this job? *"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_2_text_value"},
#  "Do you need visa sponsorship now or in the future? *\n    \n    \n    \n\n\n   --"=>
#   {"interaction"=>"select", "locators"=>"job_application_answers_attributes_3_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]},
#  "What is your state/province of residence? *"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_4_text_value"}}

# {"first_name"=>{"interaction"=>"input", "locators"=>"first_name"},
#  "last_name"=>{"interaction"=>"input", "locators"=>"last_name"},
#  "email"=>{"interaction"=>"input", "locators"=>"email"},
#  "phone_number"=>{"interaction"=>"input", "locators"=>"phone"},
#  "city"=>{"interaction"=>"input", "locators"=>"job_application[location]"},
#  "resume"=>{"interaction"=>"upload", "locators"=>"button[aria-describedby=\"resume-allowable-file-types\""},
#  "linkedin_profile "=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_0_text_value"},
#  "how_many_years_experience_do_you_have_working_in_saas_startups? "=>
#   {"interaction"=>"select",
#    "locators"=>"job_application_answers_attributes_1_answer_selected_options_attributes_1_question_option_id",
#    "option"=>"option",
#    "options"=>["Please select", "No experience", "0-2 years experience", "2+ years experience"]},
#  ""=>{"interaction"=>"input"},
#  "why_do_you_want_to_join_synthesia? "=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_2_text_value"},
#  "your_best_site_built_with_webflow_(link) "=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_3_text_value"},
#  "where_are_you_based? "=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_4_text_value"}},

# {"first_name"=>{"interaction"=>"input", "locators"=>"first_name"},
#     "last_name"=>{"interaction"=>"input", "locators"=>"last_name"},
#     "email"=>{"interaction"=>"input", "locators"=>"email"},
#     "phone_number"=>{"interaction"=>"input", "locators"=>"phone"},
#     "city"=>{"interaction"=>"input", "locators"=>"job_application[location]"},
#     "resume"=>{"interaction"=>"upload", "locators"=>"button[aria-describedby=\"resume-allowable-file-types\""},
#     "linkedin_profile"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_0_text_value"},
#     "portfolio_link/website"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_1_text_value"},
#     "how_did_you_hear_about_this_job?"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_2_text_value"},
#     "are_you_legally_authorised_to_work_in_the_uk? "=>{"interaction"=>"select", "locators"=>"job_application_answers_attributes_3_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]},
#     ""=>{"interaction"=>"input"},
#     "do_you_need_ongoing_visa_sponsorship_to_work_in_the_uk? "=>
#      {"interaction"=>"select", "locators"=>"job_application_answers_attributes_4_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]},
#     "in_the_case_my_application_is_rejected,_i_agree_that_the_personal_data_i’ve_provided_may_be_added_to_bcg_x._ventures’_talent_pool_and_used_to_contact_me_about_suitable_career_opportunities_at_bcg_x._ventures_and/or_its_portfolio_companies_for_up_to_three_years._i_acknowledge_that_i_can_withdraw_my_consent_at_any_time_by_informing_dataprotection@bcgdv.com. "=>
#      {"interaction"=>"select", "locators"=>"job_application_answers_attributes_5_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]},
#     "in_the_case_that_any_portion_of_my_candidate_application_includes_personal_data_that_could_be_considered_sensitive_(e.g._sexual_orientation,_ethnic_origin,_political_opinions,_health,_criminal_record),_i_explicitly_consent_bcg_x._ventures_to_hold_my_application_containing_this_information._note_that_bcg_x._ventures_will_never_use_this_information_to_make_a_hiring_decision. "=>
#      {"interaction"=>"select", "locators"=>"job_application_answers_attributes_6_answer_selected_options_attributes_6_question_option_id", "option"=>"option", "options"=>["Please select", "Yes"]}}

# <Job id: 1, job_title: "Cloud Network Engineer @ Gemini ", job_description: "Gemini is a crypto exchange and custodian that all...", salary: 98000, date_created: "2023-12-11", application_criteria: {"first_name"=>{"interaction"=>"input", "locators"=>"first_name"}, "last_name"=>{"interaction"=>"input", "locators"=>"last_name"}, "email"=>{"interaction"=>"input", "locators"=>"email"}, "phone_number"=>{"interaction"=>"input", "locators"=>"phone"}, "city"=>{"interaction"=>"input", "locators"=>"job_application[location]"}, "resume"=>{"interaction"=>"upload", "locators"=>"button[aria-describedby=\"resume-allowable-file-types\""}, "linkedin_profile"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_0_text_value"}, "how_did_you_hear_about_this_job?"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_1_text_value"}, "website"=>{"interaction"=>"input", "locators"=>"job_application_answers_attributes_2_text_value"}, "our_gemini_office_is_based_in_gurgaon,_india_and_the_position_requires_this_person_to_be_in_the_office_five_days_a_week. please_confirm_if_you_are_able_to_do_this. "=>{"interaction"=>"select", "locators"=>"job_application_answers_attributes_3_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]}, "if_you_are_not_located_near_our_office_in_gurgaon,_are_you_willing_to_relocate? "=>{"interaction"=>"select", "locators"=>"job_application_answers_attributes_4_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]}, "have_you_been_employed_by_gemini_in_the_past? "=>{"interaction"=>"select", "locators"=>"job_application_answers_attributes_5_boolean_value", "option"=>"option", "options"=>["--", "Yes", "No"]}, "applicant_privacy_statement "=>{"interaction"=>"checkbox", "locators"=>"applicant_privacy_statement ", "options"=>["  By clicking this box and submitting your application, you consent to our Applicant Privacy Statement."]}}, application_deadline: "2023-12-31", job_posting_url: "https://boards.greenhouse.io/embed/job_app?for=gem...", company_id: 56, created_at: "2023-12-22 09:51:18.823439000 +0000", updated_at: "2023-12-22 09:51:27.151027000 +0000", applicant_tracking_system_id: nil, ats_format_id: nil, application_details: nil, description_long: nil, responsibilities: nil, requirements: nil, benefits: nil, application_process: nil, captcha: false, employment_type: nil, location: nil, country: nil, industry: nil, seniority: nil, applicants_count: nil, cheddar_applicants_count: nil, bonus: nil, industry_subcategory: nil, office_status: nil, create_account: nil, req_cv: true, req_cover_letter: nil, req_video_interview: nil, req_online_assessment: nil, req_first_round: true, req_second_round: true, req_assessment_centre: nil>
