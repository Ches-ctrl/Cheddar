module Email
  class Hubspot
    require 'hubspot-api-client'

    def add_contact(email)
      client = ::Hubspot::Client.new(access_token: ENV.fetch('HUBSPOT_API_KEY'))

      contact_properties = {
        properties: {
          email:
        }
      }

      begin
        response = client.crm.contacts.basic_api.create(simple_public_object_input_for_create: contact_properties)
        Rails.logger.info("HubSpot contact created: #{response}")
        true
      rescue StandardError => e
        if e.message.include?("409")
          Rails.logger.info("HubSpot contact already exists: #{e.response_body}")
          true
        else
          Rails.logger.error("Error creating HubSpot contact: #{e.response_body}")
          false
        end
      end
    end
  end
end
