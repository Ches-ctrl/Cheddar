# frozen_string_literal: true

module Applier
  class DevitFormFiller < FormFiller
    private

    def submit_button
      first(:button, text: /\bsend\b/i) || first(:link, text: /\bsend\b/i)
    end
  end
end
