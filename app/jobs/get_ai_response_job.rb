class GetAiResponseJob < ApplicationJob
  queue_as :default

  RESPONSES_PER_MESSAGE = 1

  def perform(user_inputs, labels)
    p "(2) Sending form HTML to OpenAI..."
    call_openai(user_inputs, labels)
  end

  private

  def call_openai(user_inputs, labels)
    p "(3) Calling OpenAI..."
    OpenAI::Client.new.chat(
      parameters: {
        model: "gpt-3.5-turbo-1106",
        response_format: { type: "json_object" },
        messages: [{ role: "user", content: "This data is extracted from an HTML form element for a job application. Please go through it and identify (1) the form fields that need to be inputted by the user and (2) the HTML selectors that I can use capybara against to find them. Ensure the HTML selectors identify the elements uniquely. Add any additional keys required. Output the response as a JSON in the following format:
        application_criteria: {
          first_name: {
            interaction: :input,
            locators: 'firstname'
          },
          last_name: {
            interaction: :input,
            locators: 'lastname'
          },
          email: {
            interaction: :input,
            locators: 'email'
          },
          phone_number: {
            interaction: :input,
            locators: 'phone'
          },
          resume: {
            interaction: :upload,
            locators: 'input[type='file']'
          },
          salary_expectation_text: {
            interaction: :input,
            locators: 'CA_18698'
          },
          right_to_work: {
            interaction: :radiogroup,
            locators: 'fieldset[data-ui='QA_6308627']',
            option: 'label',
          },
          salary_expectation_figure: {
            interaction: :input,
            locators: 'QA_6308628'
          },
          notice_period: {
            interaction: :input,
            locators: 'QA_6308629'
          },
          preferred_pronoun_select: {
            interaction: :combobox,
            locators: 'input#input_QA_6308630_input',
            option: 'li'
          },
          preferred_pronoun_text: {
            interaction: :input,
            locators: 'QA_6308631',
          },
          employee_referral: {
            interaction: :input,
            locators: 'QA_6427777'
          }
        }
        ...etc. User inputs:
        #{user_inputs}. Labels: #{labels}"}],
        temperature: 0.7,
    })
  end
end
