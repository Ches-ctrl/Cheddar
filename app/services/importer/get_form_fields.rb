require 'nokogiri'
require 'open-uri'

module Importer
  # Core class for getting form fields using Nokogiri
  # NB. Only scrapes extra fields and combines those with the standard set of Greenhouse fields at the moment
  # Splits based on category of fields - main, custom, demographic, eeoc
  # In a standard greenhouse form, every field exists within a field tag
  # Notes - exclude dev-fields-1, hidden fields
  # Instructions:
  # 1. Parse the HTML of the job posting
  # 2. Parse the form from the HTML (check for application form)
  # 3. Get the labels
  # 3. Get the form elements (input, textarea, select), group according to their label
  # 5. Get the other characteristics for each form element
  # NB. Exclude non-relevant fields
  # TODO: Separate parsing for job-boards vs boards (embedded / customised forms)
  # TODO: Add routing logic - in future will route to either NokoFields / CapyFields or ApiFields depending on the ATS
  class GetFormFields < ApplicationTask
    def initialize
      # @job = job
      # @url = @job.posting_url
      # @url = "https://job-boards.greenhouse.io/monzo/jobs/6076740"
      @url = "https://boards.greenhouse.io/cleoai/jobs/4628944002"
      # @url = "https://boards.greenhouse.io/axios/jobs/6009256#app"
      # @url = "https://boards.greenhouse.io/11fs/jobs/4060453101"
      # @url = "https://boards.greenhouse.io/forter/jobs/7259821002"
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

      @ats_sections.each do |section_name|
        section_html = split_by_section(form, section_name)
        next unless section_present?(section_html, section_name.humanize)

        fields = split_by_field(section_html)
        results = fields.map { |field| process_field(field) }

        puts pretty_generate(results)


        # @fields[section_name] = { questions: process_fields(section_html) }
      end

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

    def split_by_section(form, css_selector)
      form.css("##{css_selector}")
    end

    def section_present?(fields, fields_name)
      fields.empty? ? puts("#{fields_name} - NO") : puts("#{fields_name} - YES")
      !fields.empty?
    end

    def split_by_field(form)
      form.css('.field')
    end

    def process_fields(fields)
      fields.map do |field|
        label = field.at('label')&.text&.strip
        inputs = field.css('input, select, textarea').map do |input|
          {
            name: input['name'],
            type: input['type'],
            value: input['value'],
            id: input['id'],
            checked: input['checked'] == 'checked'
          }
        end
        { label:, inputs: }
      end
    end

    def process_field(field)
      label = field.at('label')&.text&.strip
      options = field.css('input, select, textarea').map do |input|
        next if input['type'] == 'hidden' || input['id'].nil?

        {
          id: input['id'],
          label: get_label(field, input),
          required: input['aria-required'],
          type: input['type'] || input.name,
          value: input['value'],
          set: input['set'],
        }
      end
      { label:, options: }
    end

    # ==================

    def extract_questions(section_html)
      # TODO: Handle textarea, select & other input types
      local_fields = []

      section_html.css('input, textarea, select').each do |input|
        next if input['type'] == 'hidden' || input['type'] == 'checkbox' || input['type'] == 'radio'

        id = input['id']
        next unless id

        label = get_label(section_html, input)
        required = input['aria-required']
        max_length = input['maxlength']
        type = input['type'] || input.name
        value = input['value']
        set = input['set']

        field = {
          id:,
          label:,
          required:,
          type:,
          value:,
          set:,
          max_length:
        }

        local_fields << field
      end
      local_fields
    end

    def get_label(form, input)
      # First find a for= element, then look for label text, then return the text of the parent label element if the label is a parent of the input
      label = form.css("label[for='#{input['id']}']").text # best way for getting labels
      label.empty? ? input.parent.css('label').text.strip : label # gets labels from parent element

      label.empty? ? input.parent.children.select(&:text?).map(&:text).join.strip : label # Alternative method for getting labels
      label.gsub(/\s+/, ' ').strip # Works for Axios with above method
      label.empty? ? input.parent.text.strip : label # Old method for getting label text (works for Cleo.ai)
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

# if type == 'checkbox'
#   checkboxes[label] ||= { id:, label:, required:, type: 'checkbox', options: [] }
#   option_label = input.parent.parent.parent.css('label').text.strip
#   checkboxes[label][:options] << { text: option_label, value: input['value'] }
# else
#   field = {
#     id:,
#     label:,
#     required:,
#     type:,
#     max_length:
#   }
#   local_fields << field
# end

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

# def split_by_label(question)
#   label = question.children.select(&:text?).map(&:text).join.strip
#   puts label
# end

# def collect_radio_options(doc, input)
#   name = input['name']
#   doc.css("input[name='#{name}'][type='radio']").map do |radio|
#     { "label" => get_label(doc, radio), "value" => radio['value'] }
#   end
# end
