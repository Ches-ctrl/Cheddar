# frozen_string_literal: true

module Applier
  class GreenhouseFormFiller < FormFiller
    private

    def application_form = '#application-form'

    def click_and_answer_follow_up(value)
      value, follow_up_value = value if value.is_a?(Array)
      find(:css, "div[role='option']", text: value.strip).click
      find_by_id("#{@locator}-freeform").set(follow_up_value) if follow_up_value
    end

    def demographic_label = find_by_id("#{@locator}-label")

    def expand_demographic_select_menu
      demographic_label.sibling('div').first('div div div').click
    end

    def handle_demographic_question
      @value.each do |value|
        expand_demographic_select_menu
        click_and_answer_follow_up(value)
      end
    end

    def handle_demographic_select
      select_menu.click
      click_and_answer_follow_up(@value)
    end

    def handle_multi_select
      @value.each do |value|
        find(:css, "input[type='checkbox'][value='#{value}'][name='#{@locator}']").click
      end
    end

    def handle_select
      select_menu.click # expand
      select_option.click
    end

    def hidden_element
      find(:css, "input[type='hidden'][value='#{@locator}']")
    end

    def numerical?(string) = string.to_i.positive?

    def select_option = find("#react-select-#{@locator}-option-#{@value}")
  end
end
