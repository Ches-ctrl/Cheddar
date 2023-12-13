class MessagesController < ApplicationController
  def initialize
    @client = OpenAI::Client.new
    # @messages = []
  end

  def show
    @messages = Message.all || []
  end

  def chat
    @messages = Message.all || []
    p @messages
    new_message = Message.create(content: params[:content], self: true)
    p new_message
    content = new_message.content
    p content
    response = @client.chat(
      parameters: {
        model: 'gpt-3.5-turbo', # Choose the desired model
        messages: [{ role: 'user', content: content }],
        temperature: 0.7,
      }
    )
    output = response.dig('choices', 0, 'message', 'content')
    Message.create(content: output, self: false)
    render json: { chatbotResponse: output }
  end
end
