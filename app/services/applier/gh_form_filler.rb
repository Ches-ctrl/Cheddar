# frozen_string_literal: true

module Applier
  class GhFormFiller < FormFiller
    def initialize(payload = sample_payload)
      super
    end

    private

    def click_submit_button
      sleep 2
      p "I didn't actually submit the application."
    end

    def attach_file_to_application
      attach_file(@filepath) do
        find(@locator).click
      end
    end

    def handle_input
      return super unless @locator.to_i.positive? # unless locator is numerical

      hidden_element = find(:css, "input[type='hidden'][value='#{@locator}']")
      field = hidden_element.sibling('input', visible: true)[:id]
      fill_in(field, with: @value)
    end

    def handle_multi_select
      @value.each do |value|
        find(:css, "input[type='checkbox'][value='#{value}'][set='#{@locator}']").click
      end
    end

    def handle_demographic_question
      parent = find(:css, "input[type='hidden'][value='#{@locator}']")
               .ancestor('div', class: 'demographic_question')
      within(parent) do
        @value.each do |value|
          find(:css, "input[type='checkbox'][value='#{value}']").click
        end
      end
    end

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://boards.greenhouse.io/cleoai/jobs/4628944002',
        form_locator: '#application_form',
        fields: [
          {
            locator: 'first_name',
            interaction: :input,
            value: 'John'
          },
          {
            locator: 'last_name',
            interaction: :input,
            value: 'Smith'
          },
          {
            locator: 'email',
            interaction: :input,
            value: 'j.smith@example.com'
          },
          {
            locator: 'phone',
            interaction: :input,
            value: '(555) 555-5555'
          },
          {
            locator: "button[aria-describedby='resume-allowable-file-types']",
            interaction: :upload,
            value: File.open('public/Obretetskiy_cv.pdf')
          },
          {
            locator: 'button[aria-describedby="cover_letter-allowable-file-types"]',
            interaction: :upload,
            value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          },
          {
            locator: '27737478002',
            interaction: :input,
            value: 'I would like to earn a decent salary. I am not greedy.'
          },
          {
            locator: '18804072002',
            interaction: :multi_select,
            value: ['88174211002']
          },
          {
            locator: '24229694002',
            interaction: :multi_select,
            value: ['114986929002', '114986935002', '114986948002']
          },
          {
            locator: '4000101002',
            interaction: :demographic_question,
            value: ['4000548002', '4004737002', '4000550002']
          },
          {
            locator: '4000862002',
            interaction: :demographic_question,
            value: ['4004741002']
          }
        ]
      }
    end
  end
end
