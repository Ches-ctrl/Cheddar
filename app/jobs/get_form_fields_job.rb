require 'nokogiri'

class GetFormFieldsJob < ApplicationJob
  include Capybara::DSL

  queue_as :default

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

    # TODO: Check that including this here doesn't cause issues
    Capybara.current_session.driver.quit
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
