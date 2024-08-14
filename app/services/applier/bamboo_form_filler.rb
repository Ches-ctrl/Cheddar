# frozen_string_literal: true

module Applier
  class BambooFormFiller < FormFiller
    private

    def application_form = '#careerApplicationForm'

    def attach_file_to_application
      find("input[name='#{@locator}']", visible: false)
        .sibling('div')
        .find('input')
        .attach_file(@filepath)
      sleep 2
    end

    def boolean_field = find(:css, "label[for='#{@locator}']")

    def click_submit_button
      sleep 12 # temporary -- just for testing
      submit_button.click
    end

    def convert_date
      date_string_from_payload = @value
      @value = Date.strptime(date_string_from_payload, '%Y-%m-%d')
                   .strftime(fetch_date_format)
    end

    # Determines the strftime format based on the form element's placeholder value
    def fetch_date_format
      format_map = {
        'mm' => '%m',
        'dd' => '%d',
        'yy' => '%y',
        'yyyy' => '%Y'
      }

      find_by_id(@locator)['placeholder']
        .gsub(/[mdy]+/) { |match| format_map[match] }
    end

    # country must be filled in first
    def fill_in_all_fields
      prioritize_country_question
      super
    end

    def handle_date_picker
      convert_date
      handle_input
    end

    def handle_radiogroup
      find("label[for='#{@locator}--#{@value.downcase}']").click
    end

    def handle_select
      @hidden_select_field = find("select[name='#{@locator}']")
      return if option_prefilled?

      super
    end

    def option_prefilled? = @hidden_select_field.has_css?("option[value='#{@value}']")

    def prioritize_country_question
      target_index = @fields.index { |field| field[:locator] == 'countryId' }
      return unless target_index

      @fields.insert(0, @fields.delete_at(target_index))
    end

    def select_menu = @hidden_select_field.sibling('div')

    def select_option = page.document.find_by_id(@value, visible: true)
  end
end
