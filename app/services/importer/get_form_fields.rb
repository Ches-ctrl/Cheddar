module Importer
  # Core class for getting form fields using Nokogiri
  # Scrapes all fields from the form (including core fields); excludes dev-field-1, hidden fields
  # Splits based on category of fields - main, custom, demographic, eeoc
  # Notes - In a standard greenhouse form, every field exists within a field tag
  # Known Issues - Candidate Privacy Notice. Individual checkboxes. Identifying multi- vs single-select dropdowns. Embedded / custom job-boards
  # NB. This will not pull all the fields if there is an additional section not listed in @ats_sections
  # Allowable file types (Greenhouse): (File types: pdf, doc, docx, txt, rtf)
  # Instructions:
  # 1. Parse the HTML of the job posting
  # 2. Parse the form from the HTML (check for application form)
  # 3. Split by fields, get the labels (questions)
  # 3. Get the inputs relating to the question (input, textarea, select)
  # 5. Get the values for each input
  class GetFormFields < ApplicationTask
    def initialize
      # @job = job
      # @url = @job.posting_url
      # @url = "https://boards.greenhouse.io/cleoai/jobs/4628944002"
      @url = "https://boards.greenhouse.io/cleoai/jobs/7301308002"
      # @url = "https://boards.greenhouse.io/axios/jobs/6009256#app"
      # @url = "https://boards.greenhouse.io/11fs/jobs/4060453101"
      # @url = "https://boards.greenhouse.io/forter/jobs/7259821002"
      @ats_sections = %w[main_fields custom_fields demographic_questions eeoc_fields data_compliance security_code_fields]
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

    def process_checkbox_radio(label, field)
      id = field.at('input[type="hidden"][id*="question_id"]')['id']
      required = field.css('input[type="checkbox"], input[type="radio"]').first['aria-required']
      options = field.css('input[type="checkbox"], input[type="radio"]').map do |input|
        next if input['type'] == 'hidden'

        {
          label: get_label(field, input),
          id: input['id'], # For uniquely identifying the option
          required: input['aria-required'],
          class: input['class']
          # value: input['value'], # Useful for submitting post requests
        }
      end
      {
        label:,
        id:,
        required:,
        type: 'checkbox',
        options:
      }
    end

    def process_select(label, field)
      id = field.at('input[type="hidden"][id*="question_id"]')['id']
      required = field.css('select').first['aria-required']
      options = field.css('option').map do |option|
        next if option.text.strip == "--" || option.text.strip == "Please select"

        {
          label: option.text.strip,
          id: option['id'], # For uniquely identifying the option
          required: option['aria-required'],
          class: option['class']
          # value: option['value'], # Useful for submitting post requests
        }
      end
      {
        label:,
        id:,
        required:,
        type: 'select',
        options:
      }
    end

    def process_input(_label, field)
      # ID set to answer value at the moment but could instead by the question_id (simple gsub also works)
      field.css('input, textarea').map do |input|
        next if input['type'] == 'hidden' || input['id'].nil? || input['id'].include?('dev-field-1')

        {
          label: get_label(field, input),
          required: input['aria-required'],
          type: input['type'] || input.name,
          max_length: input['maxlength'],
          id: input['id']
          # value: input['value'], # Useful for submitting post requests
        }
      end
    end

    # First find a for= element, then look for label text - not fully working yet
    def get_label(form, input)
      label = form.css("label[for='#{input['id']}']").text # best way for getting labels
      # puts "0. #{label}"
      label.empty? ? label = input.parent.css('label').text.strip : label # gets labels from parent element
      # puts "1. #{label}"
      label.empty? ? label = input.parent.children.select(&:text?).map(&:text).join.strip : label # Alternative method for getting labels
      # puts "2. #{label}"
      label.gsub(/\s+/, ' ').strip # (Works for Axios with above method)
      # puts "3. #{label}"
      label.empty? ? label = input.parent.text.strip : label # (Works for Cleo.ai)
      # puts "4. #{label}"
      label
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

# OLD_STRUCTURE = {
#   first_name: {
#     interaction: :input,
#     locators: 'first_name',
#     required: true,
#     label: 'First Name',
#     core_field: true
#   }
# }

# NEW_STRUCTURE = {
#   section: {
#     first_name: {
#       label:,
#       id:,
#       required:,
#       type:,
#       max_length:,
#       options: [
#         {
#           label:,
#           id:,
#           required:,
#           class:,
#         }
#       ]
#     }
#   }
# }

# For testing:
# @url = "https://boards.greenhouse.io/cleoai/jobs/4628944002"
# @url = "https://boards.greenhouse.io/cleoai/jobs/7301308002"
# @url = "https://boards.greenhouse.io/axios/jobs/6009256#app"
# @url = "https://boards.greenhouse.io/11fs/jobs/4060453101"
# @url = "https://boards.greenhouse.io/forter/jobs/7259821002"
# @url = "https://job-boards.greenhouse.io/monzo/jobs/6076740"
# @url = "https://stripe.com/jobs/listing/account-executive-digital-natives/5414838/apply"
