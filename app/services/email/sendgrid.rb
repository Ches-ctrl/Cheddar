module Email
  class Sendgrid
    require 'sendgrid-ruby'
    include SendGrid

    def initialize
      @sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))
    end

    def add_contact(email)
      data = {
        contacts: [
          {
            email:
          }
        ]
      }

      response = @sg.client.marketing.contacts.put(request_body: data.to_json)
      log_response(response)
      response
    end

    def send_confirmation_email(email)
      from = SendGrid::Email.new(email: 'charlie@cheddar.jobs')
      to = SendGrid::Email.new(email:)
      subject = 'Cheddar sign up confirmation'
      content = SendGrid::Content.new(type: 'text/plain', value: 'Thank you for subscribing!')

      mail = SendGrid::Mail.new(from, subject, to, content)

      response = @sg.client.mail._('send').post(request_body: mail.to_json)
      log_response(response)
      response
    end

    private

    def log_response(response)
      puts response.status_code
      puts response.body
      puts response.headers
    end
  end
end
