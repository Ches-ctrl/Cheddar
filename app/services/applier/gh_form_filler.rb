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
            locator: 'What are your salary expectations for the role?',
            interaction: :input,
            value: 'I would like to earn a decent salary. I am not greedy.'
          },
          {
            locator: "Let's make sure you know how we handle your data 🔐",
            interaction: :multi_select,
            value: ["I've read it 🤓"]
          },
          {
            locator: 'Where did you hear about us?',
            interaction: :multi_select,
            value: ['Cleo Tech Blog', 'Silicon Milkroundabout', 'Brighton Ruby']
          },
          {
            locator: 'What is your sexual orientation?',
            interaction: :multi_select,
            value: ["I don't know"]
          }
        ]
      }
    end
  end
end
