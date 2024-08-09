# frozen_string_literal: true

module Applier
  class AshbyFormFiller < FormFiller
    private

    def attach_file_to_application
      hidden_element.attach_file(@filepath)
    end

    def boolean_string
      @value ? 'Yes' : 'No'
    end

    def click_apply_button = false

    def handle_boolean
      hidden_element
        .sibling('button', text: boolean_string)
        .click
    end

    def handle_location
      input_field = find(:css, "label[for='#{@locator}']").sibling('input')
      @value.chars.each do |char|
        input_field.send_keys(char)
        break page.document.find('div', exact_text: @value).click if page.document.has_selector?('div', exact_text: @value)
      end
      sleep 0.1 # Otherwise the pop-up menu obscures the next field
    end

    def handle_radiogroup
      response_field.choose(@value)
    end

    def hidden_element
      find_field(@locator, visible: false)
    end

    def response_field
      find(:css, "label[for='#{@locator}']").ancestor('fieldset', match: :first)
    end
  end
end
