require 'nokogiri'
require 'open-uri'

module Importer
  # Core class for getting form fields using Nokogiri
  # NB. Only scrapes extra fields and combines those with the standard set of Greenhouse fields at the moment
  # Splits based on category of fields - main, custom, demographic, eeoc
  # In a standard greenhouse form, every field exists within a field tag
  # Notes - exclude dev-fields-1, hidden fields
  # TODO: Separate parsing for job-boards vs boards (embedded / customised forms)
  # TODO: Add routing logic - in future will route to either NokoFields / CapyFields or ApiFields depending on the ATS
  class GetFormFields < ApplicationTask
    def initialize
      # @job = job
      # @url = @job.posting_url
      # @url = "https://job-boards.greenhouse.io/monzo/jobs/6076740"
      # @url = "https://boards.greenhouse.io/cleoai/jobs/4628944002"
      @url = "https://boards.greenhouse.io/axios/jobs/6009256#app"
      # @url = "https://boards.greenhouse.io/11fs/jobs/4060453101"
      # @url = "https://boards.greenhouse.io/forter/jobs/7259821002"
      # @url = "https://stripe.com/jobs/listing/account-executive-digital-natives/5414838/apply"
      @fields = {}
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

    # Instructions:
    # 1. Parse the HTML of the job posting
    # 2. Parse the form from the HTML (check for application form)
    # 3. Get the form elements (input, textarea, select)
    # 4. Get the label for each form element
    # 5. Get the other characteristics for each form element
    # NB. Exclude non-relevant fields

    def process
      p "Hello from GetFormFields!"
      doc = parse_html
      form = find_form(doc)
      return @fields unless form # Add error handling

      # This can be refactored to use a loop, with an ATS having a list of field types as a characteristic that is passed to GetFormFields
      process_fields(form, "main_fields", "Main fields")
      process_fields(form, "custom_fields", "Custom fields")
      process_fields(form, "demographic_questions", "Demographic fields")
      process_fields(form, "eeoc_fields", "EEOC fields")

      puts pretty_generate(@fields)
      @fields
    end

    def parse_html
      html = URI.parse(@url).open
      Nokogiri::HTML(html)
    end

    # Checks for forms with specific IDs, then for specific keywords, then any form
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

    def process_fields(form, css_selector, field_name)
      puts "Processing fields"
      partial_form = form.css("##{css_selector}")
      return unless fields_present?(partial_form, field_name)

      @fields[css_selector] = { questions: get_form_elements(partial_form) }
    end

    def fields_present?(fields, fields_name)
      fields.empty? ? puts("#{fields_name} - NO") : puts("#{fields_name} - YES")
      !fields.empty?
    end

    def get_form_elements(partial_form)
      puts "Getting form elements"
      # TODO: Handle textarea, select & other input types
      local_fields = []

      # Can get additional fields e.g. name, autocomplete but these have little informational value from the looks of things
      partial_form.css('input, textarea, select').each do |input|
        next if input['type'] == 'hidden'

        id = input['id']
        next unless id

        label = get_label(partial_form, input)
        required = input['aria-required']
        max_length = input['maxlength']
        type = input['type'] || input.name

        field = {
          id:,
          label:,
          required:,
          type:,
          max_length:
        }

        local_fields << field
      end
      local_fields
    end

    def get_label(form, input)
      # First find a for= element, then look for label text, then return the text of the parent label element if the label is a parent of the input
      label = form.css("label[for='#{input['id']}']").text
      label.empty? ? input.parent.css('label').text.strip : label
      label.gsub(/\s+/, ' ').strip
      # label.empty? ? input.parent.children.select(&:text?).map(&:text).join.strip : label # Alternative method for getting labels
      # label.empty? ? input.parent.text.strip : label # Old method for getting label text
    end

    def collect_radio_options(doc, input)
      name = input['name']
      doc.css("input[name='#{name}'][type='radio']").map do |radio|
        { "label" => get_label(doc, radio), "value" => radio['value'] }
      end
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

# def scrape_form(url)
#   form.css('input, textarea, select').each do |input|
#     name = input['name'] || input['id']
#     next unless name # Skip inputs without a name or id

#     field = { "name" => name, "label" => get_label(doc, input) }

#     case input.name
#     when 'input'
#       field["type"] = input['type'] || 'text'
#       field["value"] = input['value'] || ''
#       if input['type'] == 'checkbox' || input['type'] == 'radio'
#         field["checked"] = input['checked'] ? true : false
#         if input['type'] == 'radio'
#           field["options"] = collect_radio_options(doc, input)
#         end
#       end
#     when 'textarea'
#       field["type"] = 'textarea'
#       field["value"] = input.text
#     when 'select'
#       field["type"] = 'select'
#       field["options"] = input.css('option').map { |option| { "label" => option.text, "value" => option['value'] } }
#       field["value"] = input.css('option[selected]').first&.text || ''
#     end

#     fields << field
#   end
# end

# def process_main_fields(form)
#   main_fields = form.css("#main_fields")
#   fields_present?(main_fields, "Main fields")
# end

# def process_custom_fields(form)
#   custom_fields = form.css("#custom_fields")
#   fields_present?(custom_fields, "Custom fields")
# end

# def process_demographic_fields(form)
#   demographic_fields = form.css("#demographic_questions")
#   fields_present?(demographic_fields, "Demographic fields")
# end

# def process_eeoc_fields(form)
#   eeoc_fields = form.css("#eeoc_fields")
#   fields_present?(eeoc_fields, "EEOC fields")
# end
