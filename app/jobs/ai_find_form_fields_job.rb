require 'nokogiri'

class AiFindFormFieldsJob < ApplicationJob
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
    user_inputs = nokogiri_form.css('input, select, textarea').map do |element|
      {
        type: element.name, # 'input', 'select', or 'textarea'
        id: element['id'],
        name: element['name'],
        input_type: element['type'], # for 'input' elements, e.g., 'text', 'checkbox'
        required: element['required'],
        value: element['value']
      }
    end

    # Then extract labels and associate them with inputs
    labels = nokogiri_form.css('label').map do |label|
      input_id = label['for']
      input_element = user_inputs.find { |input| input[:id] == input_id }

      {
        label_text: label.text.strip,
        associated_input: input_element
      }
    end

    # Output the extracted elements
    puts "User Inputs:"
    user_inputs.each { |input| p input }

    puts "Labels with Associated Inputs:"
    labels.each { |label| p label }

    p "(1) Sending cleaned HTML to OpenAI..."

    # TODO: Install TikToken gem to check for number of tokens in message
    # TODO: OR call OpenAI API directly to check for number of tokens in message
    # NB. Maximum content window for OpenAI is 16385 tokens

    ai_response = GetAiResponseJob.perform_now(user_inputs, labels)

    p "(2) Received response from OpenAI..."
    application_criteria_string = ai_response["choices"][0]["message"]["content"]
    application_criteria = JSON.parse(application_criteria_string)

    puts "Application Criteria:"
    puts application_criteria["application_criteria"]

    job = Job.create(
      job_title: "Software Engineer-Full stack (Junior Level)",
      job_description: "Kroo has a big vision. To be the first bank that is both trusted and loved by its customers.We’re helping people take control of their financial future and achieve their goals, whilst making a positive impact on the planet. Here at Kroo, doing what is right is in our DNA. We act with integrity, transparency and honesty. We think big, dream big, and relentlessly pursue our goals. We like to be bold, break new ground, and we never stop learning. But most importantly, we are on this journey together.",
      salary: 30000,
      date_created: Date.today,
      application_criteria: application_criteria["application_criteria"],
      application_deadline: Date.today + 30,
      job_posting_url: "https://apply.workable.com/kroo/j/C51C29B6C0",
      company_id: Company.first.id)

    job_app = JobApplication.create(
      status: "Pre-test",
      user_id: User.first.id,
      job_id: Job.last.id
    )
    puts "Created job application for #{User.first.first_name} for #{Job.first.job_title}"

    ApplyJob.perform_later(JobApplication.last.id, User.first.id)
  end

  private

  def find_apply_button
    find(:xpath, "//a[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')] | //button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apply')]")
  end
end


# ---------------
# Alternative way of getting form HTML
# ---------------

# form_html = page.evaluate_script("document.querySelector('form').outerHTML")
# p "Other form: #{form_html}"


# ---------------
# OpenAI Attempt I - not working
# ---------------

# required_elements = nokogiri_form.css('label, input, select, textarea').each_with_object([]) do |element, arr|
#   if element.name == 'label'
#     # Extract label text and corresponding input details
#     input_id = element['for']
#     input_element = nokogiri_form.at_css("##{input_id}")

#     if input_element
#       arr << {
#         label: element.text.strip,
#         input_id: input_id,
#         input_name: input_element['name'],
#         input_type: input_element['type'],
#         required: input_element['required']
#       }
#     end
#   end
# end

# required_elements.each { |element| p element }


# ---------------
# OpenAI Attempt III - not working
# ---------------

# form_elements = []

# nokogiri_form.css('input, select, textarea, label').each do |element|
#   case element.name
#   when 'label'
#     # Find the associated input/select/textarea element
#     input_id = element['for']
#     input_element = nokogiri_form.at_css("[id='#{input_id}']")

#     if input_element
#       form_elements << {
#         label: element.text.strip,
#         type: input_element.name, # 'input', 'select', or 'textarea'
#         id: input_element['id'],
#         name: input_element['name'],
#         input_type: input_element['type'], # for 'input' elements, e.g., 'text', 'checkbox'
#         required: input_element['required'],
#         value: input_element['value']
#       }
#     end
#   end
# end

# # Output the extracted elements
# puts "Form Elements:"
# form_elements.each { |element| p element }

# ---------------
# OpenAI Context Length Error
# ---------------

# OpenAI HTTP Error (spotted in ruby-openai 6.3.0): {"error"=>{"message"=>"This model's maximum context length is 16385 tokens. However, your messages resulted in 30810 tokens. Please reduce the length of the messages.", "type"=>"invalid_request_error", "param"=>"messages", "code"=>"context_length_exceeded"}}

# Could do batch processing if number of tokens exceeds limit
