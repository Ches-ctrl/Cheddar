require 'nokogiri'

class GetFormFieldsJob < ApplicationJob
  include Capybara::DSL

  queue_as :default

  # TODO: add test filling out the form fields

  def perform(url)
    visit(url)
    return if page.has_selector?('#flash_pending')
    find_apply_button.click rescue nil

    # page_html = page.html
    form = find('form', text: /apply|application/i)
    form_html = page.evaluate_script("arguments[0].outerHTML", form.native)
    nokogiri_form = Nokogiri::HTML.fragment(form_html)

    fields = nokogiri_form.css('#custom_fields')
    labels = fields.css('label')

    attributes = {}
    labels.each do |label|
      label_text = label.xpath('descendant-or-self::text()[not(parent::select or parent::option or parent::ul or parent::label/input[@type="checkbox"])]').text.strip

      name = label_text # not perfect
      next if name == ""
      next if label.parent.name == 'label'

      attributes[name] = {
        interaction: :input
      }

      inputs = label.css('input', 'textarea').reject { |input| input['type'] == 'hidden' || !input['id'] }
      unless inputs.empty?
        # attributes[name][:locators] = inputs[0]['name']
        attributes[name][:locators] = inputs[0]['id']
      end

      checkbox_input = label.css('label:has(input[type="checkbox"])')
      unless checkbox_input.empty?
        attributes[name][:interaction] = :checkbox
        attributes[name][:locators] = name
        attributes[name][:options] = label.css('label:has(input[type="checkbox"])').map { |option| option.text.strip }
      end

      select_input = label.css('select')
      unless select_input.empty?
        attributes[name][:interaction] = :select
        attributes[name][:locators] = select_input[0]['id']
        attributes[name][:option] = 'option'
        attributes[name][:options] = label.css('option').map { |option| option.text.strip }
      end
    end

    # Check that including this here doesn't cause issues
    Capybara.current_session.driver.quit
    return attributes
    # attributes.delete(attributes.keys.last)
  end

  private

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end
end
