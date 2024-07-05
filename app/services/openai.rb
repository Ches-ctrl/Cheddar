# app/services/openai.rb
# Class for interacting with OpenAI, primarily for resume analysis during user onboarding in the first instance
# NB. In progress and not fully functional yet
class Openai < ApplicationTask
  def initialize
    p "Initialize"
    @client = OpenAI::Client.new
    @assistant = @client.assistants.retrieve(id: "asst_62b4xuE3RQvqlIDT1AYed0wZ")
    @file_id = "file-FRXTfhSy25cp874ExD6Tr9h7"
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
    @client
  end

  def process
    puts "Processing"
    thread_id = create_thread
    puts thread_id
    message = create_message(thread_id)
    puts message
    list_messages(thread_id)
  end

  def admin
    # Not called but kept for reference regarding the API structure
    upload_resume
    list_assistants
    list_uploaded_files
    basic_chat
  end

  def list_assistants
    response = @client.assistants.list
    puts pretty_generate(response)
  end

  def upload_resume
    puts "Uploading resume"
    my_file = File.open("public/Obretetskiy_cv.pdf", "rb")
    @client.files.upload(parameters: { file: my_file, purpose: "assistants" })
  end

  def list_uploaded_files
    puts "Checking resume uploaded"
    @client.files.list
  end

  def find_file_by_filename(list, filename)
    file = list["data"].find { |file| file["filename"] == filename }
    file["id"]
  end

  def send_resume_to_openai(_file_id)
    puts "Processing resume with OpenAI"
    response = @assistant.chat(
      parameters: {
        model: "gpt-4o",
        # file_id:,
        attachments: [
          {
            file_id: file.id,
            tools: [{ type: "file_search" }]
          }
        ],
        messages: [{ role: "user", content: "Here is my resume. Tell me my name" }],
        # messages: [{ role: "user", content: "Respond with a sample JSON"}],
        temperature: 0.7
      }
    )
    puts response
    puts pretty_generate(response.dig("choices", 0, "message", "content"))
  end

  def create_thread
    puts "Creating thread"
    thread_response = @assistant.threads.create
    thread_response['id']
  end

  def list_messages(thread_id)
    puts "Listing messages"
    messages_response = @assistant.threads.messages.list(thread_id)
    puts messages_response
  end

  def create_message(thread_id)
    puts "Creating message"
    message_response = @assistant.threads.messages.create(
      thread_id,
      {
        role: 'user',
        content: 'My name is charlie. What is my name?'
        # attachments: [
        #   {
        #     file_id: file_id,
        #     tools: [{ type: 'file_search' }]
        #   }
        # ]
      }
    )
    puts message_response
  rescue StandardError => e
    puts e
  end

  def basic_chat
    response = @client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [{ role: "user", content: "Hello!" }],
        temperature: 0.7
      }
    )
    puts response.dig("choices", 0, "message", "content")
  end

  def pretty_generate(response)
    JSON.pretty_generate(response)
  end
end
