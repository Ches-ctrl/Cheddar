# frozen_string_literal: true

module Applier
  class DevitFormFiller < FormFiller
    def initialize(payload = sample_payload)
      super
    end

    def apply_button
      first(:button, text: /apply/i) || first(:link, text: /apply/i)
    end

    def click_apply_button
      apply_button.click
    end

    def sample_payload
      {
        apply_url: 'https://devitjobs.uk/jobs/Critical-Software-Software-Engineer',
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
            interaction: :radio,
            value: 'Yes'
          }
        ]
      }
    end
  end
end
