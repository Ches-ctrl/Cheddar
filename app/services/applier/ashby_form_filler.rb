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

    def click_submit_button
      sleep 2 # temporary -- just for testing
      p "I didn't actually submit the form."
    end

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

    def multiverse_payload
      {
        user_fullname: 'Jean-Jacques Rousseau',
        apply_url: 'https://jobs.ashbyhq.com/multiverse/69afde82-dad8-4923-937e-a8d7f0551db4',
        form_locator: '#form',
        fields: [
          {
            locator: '_systemfield_name',
            interaction: :input,
            value: 'Jean-Jacques Rousseau'
          },
          {
            locator: '_systemfield_email',
            interaction: :input,
            value: 'j.j.rousseau@example.com'
          },
          {
            locator: '_systemfield_resume',
            interaction: :upload,
            value: File.open('public/Obretetskiy_cv.pdf')
          },
          {
            locator: '1e68a3c6-1709-40e3-ad14-379c7f5bb56d',
            interaction: :upload,
            value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          },
          {
            locator: '569d6217-f421-453e-b860-49a3c33c0359',
            interaction: :input,
            value: '(555) 555-5555'
          },
          {
            locator: '28412d74-aaaa-41c2-9cee-7305e6e4d496',
            interaction: :input,
            value: 'https://www.linkedin.com/in/my_profile'
          },
          {
            locator: 'a46e0f80-7b7d-4125-8edd-b17be1c967f9',
            interaction: :input,
            value: 'we/us'
          },
          {
            locator: '42fb1f5b-4a09-4039-aafe-ae7ec9ae57fd',
            interaction: :input,
            value: 'Jerry'
          },
          {
            locator: '457eb7ca-14cf-4c02-9332-7a4b31cc4623',
            interaction: :input,
            value: "This is a very good company to work for. Fantastic reviews on Glassdoor. I have long dreamed of applying to work at this company. You do amazing and innovative things!"
          },
          {
            locator: '3195b1dd-b981-434f-a7dd-7a57f4c62419',
            interaction: :input,
            value: 'No, no special adjustments.'
          },
          {
            locator: '9b73492f-1411-4863-8883-cf426cf197f0',
            interaction: :input,
            value: 'I was just googling like I usually do.'
          },
          {
            locator: 'bfdda3fa-f75f-48ef-9870-f4f168ac71ae',
            interaction: :input,
            value: '7 years.'
          },
          {
            locator: '2c1cc015-c579-4c80-954a-b10e627abbb9',
            interaction: :boolean,
            value: false
          },
          {
            locator: 'cf0f1bc7-7ce6-4eb3-aebc-b6562141cb68',
            interaction: :radiogroup,
            value: '30-39'
          },
          {
            locator: '8d7dcc65-3a0b-476a-b679-574b869780bb',
            interaction: :radiogroup,
            value: 'Another Gender Identity'
          },
          {
            locator: '0a90dc7e-908c-449f-9151-95612d844b10',
            interaction: :radiogroup,
            value: 'I prefer not to answer'
          },
          {
            locator: 'a63b6f87-d090-40f0-a462-bf5bb03f5e45',
            interaction: :multi_select,
            value: ['Lesbian', 'Gay', 'Queer', 'Other']
          },
          {
            locator: '1e21d43f-548e-481a-aa5f-f048c73f3de3',
            interaction: :multi_select,
            value: ['Asian - (Asian British, Indian, Pakistani, Bangladeshi, Chinese, Asian any other background)', 'Indigenous or Native American', 'Native Hawaiian or Other Pacific Islander', 'Mixed Ethnic Background', 'White']
          },
          {
            locator: '425ffaa2-f458-4327-84dc-1d65cd7622a7',
            interaction: :radiogroup,
            value: 'Yes'
          },
          {
            locator: '8869ac83-51af-43c9-a1f9-d0f43db306d8',
            interaction: :radiogroup,
            value: 'Yes'
          },
          {
            locator: '4ece9e72-c191-4c97-98dc-cc23b006799d',
            interaction: :radiogroup,
            value: 'Yes'
          }
        ]
      }
    end
  end
end
