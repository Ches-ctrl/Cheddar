require 'nokogiri'

class ScraperTest < ApplicationJob
  include Capybara::DSL

  queue_as :default

  # Test filling out the form fields
  # If successful, return 'success'
  # If not successful, pass result back to OpenAI to find new form fields
  # If successful, return 'success'
  # If not successful, repeat a maximum of 3 times
  # If still not successful, return 'failure'

  def perform(url)
    visit(url)
    find_apply_button.click

    # page_html = page.html
    form = find('form', text: /apply|application/i)

    # Extract form HTML from Capybara element
    form_html = page.evaluate_script("arguments[0].outerHTML", form.native)

    # Convert Capybara element to a Nokogiri element
    nokogiri_form = Nokogiri::HTML.fragment(form_html)

    # ---------------
    # OpenAI Attempt II - works
    # ---------------

    # First go through all the input values and extract required identifiers
    # user_inputs = nokogiri_form.css('input, select, textarea', 'combobox', 'radiogroup', 'listbox', 'upload').map do |element|
    #   {
    #     type: element.name, # 'input', 'select', 'textarea', 'combobox', 'radiogroup', 'listbox', 'upload'
    #     id: element['id'],
    #     name: element['name'],
    #     input_type: element['type'], # for 'input' elements, e.g., 'text', 'checkbox'
    #     required: element['required'],
    #     value: element['value']
    #   }
    # end

    # # filter out hidden elements
    # user_inputs.reject! { |input| input[:input_type] == 'hidden' || !input[:name] || !input[:id] }

    # Then extract labels and associate them with inputs
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

    return attributes
    # attributes.delete(attributes.keys.last)

    # TODO:
    # add this to job.rb create method
    # close the browser window

  end

  private

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end
end
