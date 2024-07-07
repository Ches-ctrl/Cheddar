module Importer
  # Core class for getting form fields using Nokogiri
  # Scrapes all fields from the form (including core fields); excludes dev-field-1, hidden fields
  # Splits based on category of fields - main, custom, demographic, eeoc
  # Notes - In a standard greenhouse form, every field exists within a field tag
  # Known Issues - Candidate Privacy Notice. Individual checkboxes. Identifying multi- vs single-select dropdowns. Embedded / custom job-boards
  # Instructions:
  # 1. Parse the HTML of the job posting
  # 2. Parse the form from the HTML (check for application form)
  # 3. Split by fields, get the labels (questions)
  # 3. Get the inputs relating to the question (input, textarea, select)
  # 5. Get the values for each input
  # Allowable file types (Greenhouse): (File types: pdf, doc, docx, txt, rtf)
  # TODO: Handle security codes (verification fields)
  class GetFormFields < ApplicationTask
    def initialize
      # @job = job
      # @url = @job.posting_url
      # @url = "https://job-boards.greenhouse.io/monzo/jobs/6076740"
      # @url = "https://boards.greenhouse.io/cleoai/jobs/4628944002"
      # @url = "https://boards.greenhouse.io/axios/jobs/6009256#app"
      # @url = "https://boards.greenhouse.io/11fs/jobs/4060453101"
      @url = "https://boards.greenhouse.io/forter/jobs/7259821002"
      # @url = "https://stripe.com/jobs/listing/account-executive-digital-natives/5414838/apply"
      @ats_sections = %w[main_fields custom_fields demographic_questions eeoc_fields]
      @fields = {}
      @errors = false
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

    # HTML > Form > Section > Field > Label > Input > Options
    def process
      p "Hello from GetFormFields!"
      doc = parse_html
      form = find_form(doc)
      return @fields unless form

      @ats_sections.each { |section_name| process_section(form, section_name) }

      puts pretty_generate(@fields)
      @fields
    end

    def parse_html
      html = URI.parse(@url).open
      Nokogiri::HTML(html)
    end

    def find_form(doc)
      form = doc.css('form#application-form, form#application_form').first
      return form if form

      form = doc.css('form[id*=application], form[id*=apply]').first
      return form if form

      form = doc.css('form').first
      return form
    rescue StandardError => e
      "Form not found: #{e.message}"
    end

    def section_present?(fields, fields_name)
      fields.empty? ? puts("#{fields_name} - NO") : puts("#{fields_name} - YES")
      !fields.empty?
    end

    def process_section(form, section_name)
      section_html = split_by_section(form, section_name)
      return unless section_present?(section_html, section_name.humanize)

      fields = split_by_field(section_html)
      results = fields.map { |field| process_field(field) }
      results = results.flatten.compact

      @fields[section_name] = { questions: results }
    end

    def split_by_section(form, css_selector)
      form.css("##{css_selector}")
    end

    def split_by_field(section_html)
      section_html.css('.field')
    end

    def process_field(field)
      label = field.xpath('descendant-or-self::text()[not(parent::select or parent::option or parent::ul or parent::label/input[@type="checkbox"])]').text.strip

      if field.css('input[type="checkbox"], input[type="radio"]').any?
        process_checkbox_radio(label, field)
      elsif field.css('select').any?
        process_select(label, field)
      else
        process_input(label, field)
      end
    end

    def process_input(_label, field)
      field.css('input, textarea').map do |input|
        next if input['type'] == 'hidden' || input['id'].nil? || input['id'].include?('dev-field-1')

        {
          label: get_label(field, input),
          required: input['aria-required'],
          type: input['type'] || input.name,
          max_length: input['maxlength'],
          id: input['id']
          # set: input['set'],
          # value: input['value'], # Useful for submitting post requests
        }
      end
    end

    def process_select(label, field)
      options = field.css('option').map do |option|
        next if option.text.strip == "--" || option.text.strip == "Please select"

        {
          option: option.text.strip,
          class: option['class']
          # id: option['id'], # For uniquely identifying the option
          # value: option['value'], # Useful for submitting post requests
        }
      end
      { label:, type: 'select', options: }
    end

    def process_checkbox_radio(label, field)
      options = field.css('input[type="checkbox"], input[type="radio"]').map do |input|
        next if input['type'] == 'hidden'

        {
          option: get_label(field, input),
          class: input['class']
          # id: input['id'], # For uniquely identifying the option
          # value: input['value'], # Useful for submitting post requests
        }
      end
      { label:, type: 'checkbox', options: }
    end

    # First find a for= element, then look for label text
    def get_label(form, input)
      label = form.css("label[for='#{input['id']}']").text # best way for getting labels
      label.empty? ? input.parent.css('label').text.strip : label # gets labels from parent element
      label.empty? ? input.parent.children.select(&:text?).map(&:text).join.strip : label # Alternative method for getting labels
      label.gsub(/\s+/, ' ').strip # (Works for Axios with above method)
      label.empty? ? input.parent.text.strip : label # (Works for Cleo.ai)
    end

    # May need to remove trailing asterisk, underscore or space
    def remove_trailing_asterisk(string)
      string[-1] == '*' ? string[...-1] : string
    end

    def remove_trailing_underscore(string)
      string[-1] == '_' ? string[...-1] : string
    end

    def remove_trailing_space(string)
      string.strip
    end

    def pretty_generate(json)
      JSON.pretty_generate(json)
    end
  end
end

# Old label methods:
# label = field.children.select { |node| node.text? && node.content.strip != '' }.map(&:text).join.strip
# puts "0. #{label}"
# label = field.css('label').map(&:text).join(' ')
# puts "1. #{label}"
# label = field.css('label').text.strip
# puts "2. #{label}"
