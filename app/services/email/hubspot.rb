module Email
  class Hubspot
    # require 'hubspot-api-client'

    # def initialize
    #   @client = Hubspot::Client.new(access_token: ENV.fetch('HUBSPOT_API_KEY'))
    # end

    # def add_contact(email)
    #   contact_properties = {
    #     properties: {
    #       email:
    #     }
    #   }

    #   begin
    #     response = @client.crm.contacts.basic_api.create(contact_properties)
    #     p "HubSpot contact created: #{response.to_json}"
    #     Rails.logger.info("HubSpot contact created: #{response.to_json}")
    #     true
    #   rescue Hubspot::ApiError => e
    #     p "Error creating HubSpot contact: #{e.response_body}"
    #     Rails.logger.error("Error creating HubSpot contact: #{e.response_body}")
    #     false
    #   end
    # end
  end
end
