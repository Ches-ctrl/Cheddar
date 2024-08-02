# frozen_string_literal: true

module Applier
  class WorkableFormFiller < FormFiller
    def initialize(payload)
      Capybara.configure { |config| config.test_id = :'data-ui' }
      super
    end

    private

    def application_form = 'form[data-ui="application-form"]'

    def boolean_checkbox? = has_selector?("##{@locator}")

    def boolean_group = find(:fieldset, @locator)

    def boolean_string = @value ? 'yes' : 'no'

    def click_apply_button = false

    def group_section = find("div[data-ui='#{@locator}']")

    def handle_boolean
      return super if boolean_checkbox?

      boolean_group
        .find('span', text: boolean_string)
        .click
    end

    def handle_date
      handle_input
      send_keys(:return) # close datepicker
    end

    def handle_group
      within group_section do
        click_button('add-section')
        @value.each { |field| fill_in_field(field) }
        click_button('save-section')
      end
      sleep 0.2 # avoid javascript error
    end

    def select_menu = find("div[data-ui='#{@locator}']")

    def select_option = find("li[value='#{@value}']")
  end
end
