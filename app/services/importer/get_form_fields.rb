require 'nokogiri'
require 'open-uri'

module Importer
  # Core class for getting form fields using Nokogiri/Capybara
  # NB. Only scrapes extra fields and combines those with the standard set of Greenhouse fields at the moment
  # TODO: Add routing logic - in future will route to either NokoFields / CapyFields or ApiFields depending on the ATS
  class GetFormFields < ApplicationTask
    def initialize
      # @job = job
      # @url = @job.posting_url
      @url = "https://job-boards.greenhouse.io/monzo/jobs/6076740"
    end

    def call
      return unless processable

      process
    rescue StandardError => e
      Rails.logger.error "Error running GetFormFields: #{e.message}"
      nil
    end

    private

    def processable
      @url # && @job
    end

    def process
      p "Hello from GetFormFields!"
      scrape_page
    end

    def scrape_page
      # return unless @job.api_url&.include?('greenhouse') # Not yet able to handle Lever or DevIT job

      doc = parse_html
      form = parse_form(doc)

      labels = form.css('label')

      attributes = {}

      labels.each do |label|
        # Could do this based off of name of ID
        # TODO: Add ability to deal with boolean required fields. Input will have an asterisk in a span class in that case
        # TODO: Fix issue where additional core fields will be shown to the user even if not required when included in the core greenhouse set

        # Stripping text, downcasing and replacing spaces with underscores to act as primary keys
        label_text = label.xpath('descendant-or-self::text()[not(parent::select or parent::option or parent::ul or parent::label/input[@type="checkbox"])]').text

        p label_text

        required = label_text.include?("*")
        label_text = label_text.split("*")[0]

        name = label_text&.strip&.downcase&.gsub(" ", "_")
        standard_fields = ['first_name', 'last_name', 'email', 'phone', 'resume/cv', 'cover_letter', 'city', 'location_(city)']
        next if name.blank? || standard_fields.include?(remove_trailing_underscore(name))
        next if label.parent.name == 'label'

        attributes[name] = {
          interaction: :input,
          required:,
          label: label_text
        }

        p attributes[name]

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
        demographics = form.css("#demographic_questions")
        demographics_questions = demographics.css(".demographic_question")
        demographics_questions.each do |question|
          label = question.children.select(&:text?).map(&:text).join.strip
          name = label.downcase.gsub(" ", "_")
          required = question['class'].include?('required')
          attributes[name] = {
            interaction: :checkbox,
            required:,
            label:
          }
          demographics_input = question.css('label:has(input[type="checkbox"])')
          next if demographics_input.empty?

          attributes[name][:locators] = question.children.select(&:text?).map(&:text).join.gsub("\n", ' ').strip
          attributes[name][:options] = question.css('label:has(input[type="checkbox"])').map do |option|
            option.text.strip
          end
          p attributes[name]
        end
      rescue Nokogiri::ElementNotFound
        @errors = true
      end

      extra_fields = attributes

      p extra_fields

      # @job.requirement.no_of_qs = attributes.keys.count

      # unless extra_fields.nil?
      #   @job.application_criteria = @job.application_criteria.merge(extra_fields)
      #   p @job.application_criteria
      # end
      # @job.apply_with_cheddar = true
      # @job.save

      attributes
    end

    private

    def parse_html
      html = URI.parse(@url).open
      Nokogiri::HTML(html)
    end

    def parse_form(doc)
      doc.css('form').first
    end

    def remove_trailing_underscore(string)
      string[-1] == '_' ? string[...-1] : string
    end
  end
end
