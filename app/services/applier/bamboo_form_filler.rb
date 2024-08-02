# frozen_string_literal: true

module Applier
  class BambooFormFiller < FormFiller
    private

    def application_form = '#careerApplicationForm'

    def attach_file_to_application
      find("input[name='#{@locator}']")
        .sibling('div')
        .find('input')
        .attach_file(@filepath)
    end

    def boolean_field = find(:css, "label[for='#{@locator}']")

    def handle_select
      @hidden_select_field = find("select[name='#{@locator}']")
      return if option_prefilled?

      super
    end

    def option_prefilled? = @hidden_select_field.has_css?("option[value='#{@value}']")

    def select_menu = @hidden_select_field.sibling('div')

    def select_option = page.document.find_by_id(@value, visible: true)
  end
end
