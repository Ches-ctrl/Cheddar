# frozen_string_literal: true

module Applier
  class DevitFormFiller < FormFiller
    def initialize(payload = sample_payload)
      super
    end

    def submit_button
      first(:button, text: /\bsend\b/i) || first(:link, text: /\bsend\b/i)
    end

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://devitjobs.uk/jobs/Critical-Software-Software-Engineer',
        form_locator: 'form',
        fields: [
          {
            locator: 'name',
            interaction: :input,
            value: 'John Smith'
          },
          {
            locator: 'email',
            interaction: :input,
            value: 'j.smith@example.com'
          },
          {
            locator: 'isFromEurope',
            interaction: :radiogroup,
            value: 'Yes'
          },
          {
            locator: '#cvFileId',
            interaction: :upload,
            value: File.open('public/Obretetskiy_cv.pdf')
          },
          {
            locator: 'motivationLetter',
            interaction: :input,
            value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          }
        ]
      }
    end
  end
end
