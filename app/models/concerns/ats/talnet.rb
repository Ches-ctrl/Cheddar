module Ats
  module Talnet
    extend ActiveSupport::Concern

    def self.get_company_details(company)
      p "Getting tal company details: #{company}"
    end

    TALNET_FIELDS = {
      # first_name: {
      #   interaction: :input,
      #   locators: 'firstname'
      # },
      # last_name: {
      #   interaction: :input,
      #   locators: 'lastname'
      # },
      # email: {
      #   interaction: :input,
      #   locators: 'email'
      # },
      # phone_number: {
      #   interaction: :input,
      #   locators: 'phone'
      # },
      # resume: {
      #   interaction: :upload,
      #   locators: 'input[data-ui="resume"]'
      # },
      # # address: {
      # #   interaction: :input,
      # #   locators: 'address'
      # # },
    }
  end
end
