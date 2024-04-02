require 'nokogiri'

# This file is properly specific to Greenhouse

class GetFormFieldsJob < ApplicationJob
  include Capybara::DSL

  queue_as :default
  sidekiq_options retry: false

  # TODO: Generalise to all supported ATS systems
  # TODO: Calculate total number of input fields and implied difficulty of application
  # TODO: Potentially change to scraping all fields from the job posting
  # TODO: Add boolean cv required based on this scrape
  # TODO: add test of filling out the form fields before job goes live

  def perform(job)
    return if job.api_url.include?('lever') # Not yet able to handle Lever jobs
    return if job.api_url.include?('devit') # Not yet able to handle DevIT jobs

    Capybara.current_driver = :selenium_chrome_headless

    visit(job.job_posting_url)
    return if page.has_selector?('#flash_pending')

    begin
      find_apply_button.click
    rescue StandardError
      nil
    end

    # Find Form Fields

    form = find('form', text: /apply|application/i)
    form_html = page.evaluate_script("arguments[0].outerHTML", form.native)
    nokogiri_form = Nokogiri::HTML.fragment(form_html)

    labels = nokogiri_form.css('label')

    attributes = {}
    labels.each do |label|
      # Could do this based off of name of ID

      # TODO: Add ability to deal with boolean required fields. Input will have an asterisk in a span class in that case
      # TODO: Fix issue where additional core fields will be shown to the user even if not required when included in the core greenhouse set

      # Stripping text, downcasing and replacing spaces with underscores to act as primary keys

      label_text = label.xpath('descendant-or-self::text()[not(parent::select or parent::option or parent::ul or parent::label/input[@type="checkbox"])]').text.strip.downcase.gsub(
        " ", "_"
      )

      required = label_text.include?("*")
      label_text = label_text.split("*")[0]

      name = label_text
      standard_fields = ['first_name', 'last_name', 'email', 'phone', 'resume/cv', 'cover_letter', 'city']
      next if !name || name == "" || standard_fields.include?(remove_trailing_underscore(name))
      next if label.parent.name == 'label'

      attributes[name] = {
        interaction: :input,
        required:
      }

      inputs = label.css('input', 'textarea').reject { |input| input['type'] == 'hidden' || !input['id'] }
      attributes[name][:locators] = inputs[0]['id'] unless inputs.empty?

      checkbox_input = label.css('label:has(input[type="checkbox"])')
      unless checkbox_input.empty?
        attributes[name][:interaction] = :checkbox
        attributes[name][:locators] = name.humanize.chars.reject { |char| char.ord == 160 }.join
        attributes[name][:options] = label.css('label:has(input[type="checkbox"])').map { |option| option.text.strip }
      end

      select_input = label.css('select')
      next if select_input.empty?

      attributes[name][:interaction] = :select
      attributes[name][:locators] = select_input[0]['id']
      attributes[name][:option] = 'option'
      attributes[name][:options] = label.css('option').map { |option| option.text.strip }
    end

    begin
      demographics = nokogiri_form.css("#demographic_questions")
      demographics_questions = demographics.css(".demographic_question")
      demographics_questions.each do |question|
        name = question.children.select(&:text?).map(&:text).join.strip.downcase.gsub(" ", "_")
        attributes[name] = {
          interaction: :checkbox
        }
        demographics_input = question.css('label:has(input[type="checkbox"])')
        next if demographics_input.empty?

        attributes[name][:locators] =
          attributes[name][:locators] = question.children.select(&:text?).map(&:text).join.gsub("\n", ' ').strip
        attributes[name][:options] = question.css('label:has(input[type="checkbox"])').map do |option|
          option.text.strip
        end
        p attributes[name]
      end
    rescue Capybara::ElementNotFound
      @errors = true
    end

    Capybara.current_session.driver.quit

    extra_fields = attributes

    p "job is #{job}"

    job.no_of_questions = attributes.keys.count

    unless extra_fields.nil?
      job.application_criteria = job.application_criteria.merge(extra_fields)
      p job.application_criteria
    end
    job.apply_with_cheddar = true
    job.save

    # TODO: Check that including this here doesn't cause issues
    return attributes
  end

  private

  def find_apply_button
    find(:xpath,
         "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end

  def remove_trailing_underscore(string)
    string[-1] == '_' ? string[...-1] : string
  end
end
