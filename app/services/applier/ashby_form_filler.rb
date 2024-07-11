# frozen_string_literal: true

module Applier
  class AshbyFormFiller < FormFiller
    def initialize(payload = sample_payload)
      super
    end

    def attach_file_to_application
      hidden_element.attach_file(@filepath)
    end

    def click_submit_button
      sleep 2 # temporary -- just for testing
      p "I didn't actually submit the form."
    end

    def handle_location
      input_field = find(:css, "label[for='#{@locator}']").sibling('input')
      @value.chars.each do |char|
        input_field.send_keys(char)
        break page.document.find('div', exact_text: @value).click if page.document.has_selector?('div', exact_text: @value)
      end
      sleep 0.1 # Otherwise the pop-up menu obscures the next field
    end

    def hidden_element
      find("##{@locator}", visible: false)
    end

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://jobs.ashbyhq.com/lightdash/9efa292a-cc34-4388-90a2-2bed5126ace4',
        form_locator: '#form',
        fields: [
          {
            locator: '_systemfield_name',
            interaction: :input,
            value: 'John Smith'
          },
          {
            locator: '_systemfield_email',
            interaction: :input,
            value: 'j.smith@example.com'
          },
          {
            locator: '00415714-75f3-49b9-b856-ac674fd5ce8b',
            interaction: :location,
            value: 'London, Greater London, England, United Kingdom'
          },
          {
            locator: '36913b1f-c34f-4693-919c-400304a2a11d',
            interaction: :input,
            value: 'https://www.linkedin.com/in/my_profile'
          },
          {
            locator: 'f93bff8c-2442-42b7-b040-3876fa160aba',
            interaction: :input,
            value: "This is a very good company to work for. Fantastic reviews on Glassdoor. I have long dreamed of applying to work at this company. You do amazing and innovative things!"
          },
          {
            locator: '_systemfield_resume',
            interaction: :upload,
            value: File.open('public/Obretetskiy_cv.pdf')
          }
        ]
      }
    end
  end
end
