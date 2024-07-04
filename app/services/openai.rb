# app/services/openai.rb
# Class for interacting with OpenAI, primarily for resume analysis during user onboarding in the first instance
# NB. In progress and not fully functional yet
# How this works:
# 1. Initialize the OpenAI client and assistant
# 2. Create a thread
# 3. Upload the resume file
# 4. Add the file to the thread
# 5. Run the thread through the assistant
# 6. Return the response & save to cloudinary
# 7. Update the user_details with the response
# NB. Note that threads are independent of assistants and thus must be created on @client rather than @assistant
# NB. May need to use vector stores?
# HelloGPT - asst_eX0JDDQHnRtmOOgWdB0rNuKY
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
    @client && @assistant && @file_id
  end

  def process
    puts "Processing"
    # file = upload_file
    # file = retrieve_file

    thread_id = create_thread
    create_message(thread_id)

    run_id, thread_id = create_thread_and_run
    sleep 1

    # run_id = run_thread(thread_id)
    poll_response_status(run_id, thread_id)

    messages = @client.messages.list(thread_id:, parameters: { order: 'asc' })

    puts pretty_generate(messages)

    # delete_thread(thread_id)
    # delete_file(file)
  end

  def upload_file
    puts "Uploading resume"
    my_file = File.open("public/Obretetskiy_cv.pdf", "rb")
    @client.files.upload(parameters: { file: my_file, purpose: "assistants" })
  end

  # Used in testing to prevent the need to upload the file each time
  def retrieve_file
    puts "Retrieving file"
    @client.files.retrieve(id: @file_id)
  end

  def create_thread
    puts "Adding file to thread"
    thread_response = @client.threads.create
    thread_response["id"]
  end

  def create_message(thread_id)
    puts "Creating message"
    message = @client.messages.create(
      thread_id:,
      parameters: {
        role: "user",
        content: "The name on my CV is Charlie. What is my name?"
      }
    )
    puts pretty_generate(message)
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def run_thread(thread_id)
    puts "Running thread"
    run = @client.runs.create(thread_id:,
                              parameters: {
                                assistant_id: "asst_62b4xuE3RQvqlIDT1AYed0wZ",
                                max_prompt_tokens: 256,
                                max_completion_tokens: 16
                              })
    run["id"]
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def poll_response_status(run_id, thread_id)
    puts "Polling response status"
    loop do
      response = @client.runs.retrieve(id: run_id, thread_id:)
      status = response['status']

      case status
      when 'queued', 'in_progress', 'cancelling'
        puts 'Sleeping'
        sleep 3
      when 'completed'
        puts 'Completed'
        break
      when 'requires_action'
        puts 'Requires action'
      when 'cancelled', 'failed', 'expired'
        puts "Run failed"
        puts response
        puts response['last_error'].inspect
        break
      else
        puts "Unknown status response: #{status}"
      end
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def create_thread_and_run
    puts "Creating thread and running"
    response = @client.runs.create_thread_and_run(parameters: { assistant_id: "asst_eX0JDDQHnRtmOOgWdB0rNuKY" })
    run_id = response['id']
    thread_id = response['thread_id']
    [run_id, thread_id]
  end

  def pretty_generate(response)
    JSON.pretty_generate(response)
  end
end
