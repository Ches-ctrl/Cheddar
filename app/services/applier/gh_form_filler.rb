# frozen_string_literal: true

module Applier
  class GhFormFiller < FormFiller
    private

    def application_form = '#application_form'

    def attach_file_to_application
      attach_file(@filepath) do
        find(@locator).click
      end
    end

    def click_and_answer_follow_up(checkbox, follow_up_value)
      checkbox.click
      return unless follow_up_value

      find(:css, "input[type='text']", focused: true).set(follow_up_value)
    end

    def click_apply_button = false

    def handle_demographic_question
      parent = find(:css, "input[type='hidden'][value='#{@locator}']")
               .ancestor('div', class: 'demographic_question')
      within parent do
        @value.each do |value|
          value, follow_up_value = value if value.is_a?(Array)
          checkbox = find(:css, "input[type='checkbox'][value='#{value}']")
          click_and_answer_follow_up(checkbox, follow_up_value)
        end
      end
    end

    def handle_input
      return super unless locator_is_numerical?

      field = hidden_element.sibling(:css, 'input, textarea', visible: true)[:id]
      fill_in(field, with: @value)
    end

    def handle_multi_select
      @value.each do |value|
        find(:css, "input[type='checkbox'][value='#{value}'][set='#{@locator}']").click
      end
    end

    def handle_select
      hidden_element.sibling('div', visible: true).click
      page.document.find('li', text: selector_text, visible: true).click
    end

    def hidden_element
      find(:css, "input[type='hidden'][value='#{@locator}']")
    end

    def locator_is_numerical?
      @locator.to_i.positive?
    end

    def selector_text
      within(hidden_element.sibling(:css, "select", visible: false)) do
        find(:css, "option[value='#{@value}']").text
      end
    end
  end
end
