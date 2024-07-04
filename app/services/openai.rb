# app/services/openai.rb
# Class for interacting with OpenAI, primarily for resume analysis during user onboarding
# How this works:
# 1. Initialize the OpenAI client and assistant
# 2. Upload the resume file
# 3. Create a file vector store including the uploaded file
# 4. Create a thread and run (in a single command) with the vector store attached
# 5. Poll the response status until it is completed
# 6. Retrieve the response
# 7. Save the response to cloudinary as a raw JSON object (TBD)
# 8. Delete the thread, vector store, and file
# 9. Update the user_details with the response (TBD)
# NB. Note that threads are independent of assistants and thus must be created on @client rather than @assistant
class Openai < ApplicationTask
  # TODO: Pass a CV in as a url rather than a local file
  # TODO: Constrain output to JSON only
  # TODO: Improve quality of response so that more fields are filled
  # TODO: Split into an inherited class so that we can use AI in other areas of hte app
  def initialize
    p "Initialize"
    @client = OpenAI::Client.new
    @assistant = @client.assistants.retrieve(id: "asst_62b4xuE3RQvqlIDT1AYed0wZ")
    # @file_id = "file-FRXTfhSy25cp874ExD6Tr9h7" # Obretetskiy_cv - kept for testing
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
    @client && @assistant
  end

  def process
    puts "Processing"
    file = upload_file
    store = create_vector_store(file)

    run_id, thread_id = create_thread_and_run(store)
    poll_response_status(run_id, thread_id)

    messages = @client.messages.list(thread_id:, parameters: { order: 'asc' })
    value = messages.dig("data", 0, "content", 0, "text", "value")
    puts value

    # delete_thread(thread_id)
    delete_vector_store(store)
    delete_file(file)
    # list_vector_stores
    # list_files
  end

  def upload_file
    puts "Uploading resume"
    my_file = File.open("public/Obretetskiy_cv.pdf", "rb")
    @client.files.upload(parameters: { file: my_file, purpose: "assistants" })
  end

  def create_vector_store(file)
    puts "Creating vector store"
    date = date_created
    response = @client.vector_stores.create(
      parameters: {
        name: "#{date} - Resume",
        file_ids: [file['id']]
      }
    )
    puts pretty_generate(response)
    response
  end

  def create_thread_and_run(store)
    puts "Creating thread and running"
    response = @client.runs.create_thread_and_run(
      parameters: {
        assistant_id: "asst_62b4xuE3RQvqlIDT1AYed0wZ",
        tool_resources: {
          file_search: {
            vector_store_ids: [store['id']]
          }
        }
      }
    )
    [response['id'], response['thread_id']]
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
        sleep 1
      when 'completed'
        puts 'Completed'
        break
      when 'requires_action'
        puts 'Requires action'
      when 'cancelled', 'failed', 'expired'
        puts "Run failed"
        puts response['last_error'].inspect
        break
      else
        puts "Unknown status response: #{status}"
      end
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def delete_thread(thread_id)
    puts "Deleting thread"
    @client.threads.delete(id: thread_id)
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def delete_vector_store(store)
    puts "Deleting vector store"
    @client.vector_stores.delete(id: store['id'])
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def delete_file(file)
    puts "Deleting file"
    response = @client.files.delete(id: file['id'])
    puts pretty_generate(response)
    response
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  def list_vector_stores
    puts "Listing vector stores"
    response = @client.vector_stores.list
    puts pretty_generate(response)
  end

  def list_files
    puts "Checking resume uploaded"
    response = @client.files.list
    puts pretty_generate(response)
  end

  def date_created
    Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def pretty_generate(response)
    JSON.pretty_generate(response)
  end
end
