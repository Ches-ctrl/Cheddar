require 'nokogiri'

# This file is properly specific to Greenhouse

class GetFormFieldsJob < ApplicationJob
  include Capybara::DSL

  queue_as :default
  sidekiq_options retry: false

  def perform(url)
    visit(url)
    return if page.has_selector?('#flash_pending')
    find_apply_button.click rescue nil

    job = Job.find_by(job_posting_url: url)

    form = find('form', text: /apply|application/i)
    form_html = page.evaluate_script("arguments[0].outerHTML", form.native)
    nokogiri_form = Nokogiri::HTML.fragment(form_html)

    labels = nokogiri_form.css('label')

    attributes = {}
    labels.each do |label|

      label_text = label.xpath('descendant-or-self::text()[not(parent::select or parent::option or parent::ul or parent::label/input[@type="checkbox"])]').text.strip.downcase.gsub(" ", "_")

      required = label_text.include?("*") ? true : false
      label_text = label_text.split("*")[0]

      name = label_text
      standard_fields = ['first_name', 'last_name', 'email', 'phone', 'resume/cv', 'cover_letter', 'city']
      next if !name || name == "" || standard_fields.include?(remove_trailing_underscore(name))
      next if label.parent.name == 'label'

      attributes[name] = {
        interaction: :input,
        required: required
      }

      inputs = label.css('input', 'textarea').reject { |input| input['type'] == 'hidden' || !input['id'] }
      unless inputs.empty?
        attributes[name][:locators] = inputs[0]['id']
      end

      checkbox_input = label.css('label:has(input[type="checkbox"])')
      unless checkbox_input.empty?
        attributes[name][:interaction] = :checkbox
        attributes[name][:locators] = name.humanize.chars.reject { |char| char.ord == 160 }.join
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

    begin
      demographics = nokogiri_form.css("#demographic_questions")
      demographics_questions = demographics.css(".demographic_question")
      demographics_questions.each do |question|
        name = question.children.select { |c| c.text? }.map(&:text).join.strip.downcase.gsub(" ", "_")
        attributes[name] = {
          interaction: :checkbox
        }
        demographics_input = question.css('label:has(input[type="checkbox"])')
        unless demographics_input.empty?
          attributes[name][:locators] = attributes[name][:locators] = question.children.select { |c| c.text? }.map(&:text).join.gsub("\n", ' ').strip
          attributes[name][:options] = question.css('label:has(input[type="checkbox"])').map { |option| option.text.strip }
          p attributes[name]
        end
      end
    rescue Capybara::ElementNotFound
      @errors = true
    end

    Capybara.current_session.driver.quit

    extra_fields = attributes

    unless extra_fields.nil?
      job.application_criteria = job.application_criteria.merge(extra_fields)
      job.save
      p job.application_criteria
    end

    return attributes
  end

  private

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end

  def remove_trailing_underscore(string)
    string[-1] == '_' ? string[...-1] : string
  end
end
