# app/services/openai.rb
# Class for interacting with OpenAI, primarily for resume analysis during user onboarding in the first instance
class Openai < ApplicationTask
  def initialize
    p "Initialize"
    @client = OpenAI::Client.new
  end

  def call
    return unless processable

    process
  rescue StandardError => e
    Rails.logger.error "Error submitting resume to OpenAI: #{e.message}"
    nil
  end

  private

  def processable
    puts "Processable"
    @client
  end

  def process
    puts "Processing"
    # list_assistants
    # upload_resume
    # check_resume_uploaded
    # send_resume_to_openai
  end

  def admin
    # Not called but kept for reference regarding the API structure
    list_assistants
    check_resume_uploaded
    basic_chat
  end

  def list_assistants
    response = @client.assistants.list
    pretty_response = JSON.pretty_generate(response)
    puts pretty_response
  end

  def upload_resume
    puts "Uploading resume"
    my_file = File.open("public/Obretetskiy_cv.pdf", "rb")
    @client.files.upload(parameters: { file: my_file, purpose: "assistants" })
  end

  def check_resume_uploaded
    puts "Checking resume uploaded"
    puts @client.files.list
  end

  def send_resume_to_openai
    response = @client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [{ role: "user", content: "Respond with a sample JSON"}],
        temperature: 0.7
      }
    )
    puts response.dig("choices", 0, "message", "content")
  end

  def basic_chat
    response = @client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [{ role: "user", content: "Hello!"}],
        temperature: 0.7
      }
    )
    p response.dig("choices", 0, "message", "content")
  end
end
