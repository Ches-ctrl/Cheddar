# frozen_string_literal: true

# Class responsible for storing API JSON data locally to prevent the need for multiple API calls
# Works by saving JSON data to a file and fetching it when needed
class LocalDataStorage
  attr_reader :local_storage_path

  def initialize(source)
    @source = source
    @date = Date.today.strftime('%Y-%m-%d')
    @local_storage_path = build_local_storage_path
    create_local_folder
  end

  def fetch_local_data
    file_path = jobs_data_file_path
    return unless File.exist?(file_path)

    log_data_found_locally
    parse_json(read_file(file_path))
  end

  def save_jobs_data(jobs_data)
    file_path = jobs_data_file_path
    write_file(file_path, create_json(jobs_data))
    log_saved_locally
  end

  private

  def build_local_storage_path
    Rails.root.join('public', 'data', @source, @date)
  end

  def create_local_folder
    FileUtils.mkdir_p(@local_storage_path)
  end

  def jobs_data_file_path
    File.join(@local_storage_path, 'jobs.json')
  end

  def read_file(file_path)
    File.read(file_path)
  end

  def parse_json(json_data)
    JSON.parse(json_data)
  end

  def write_file(file_path, json_data)
    File.write(file_path, json_data)
  end

  def create_json(data)
    JSON.pretty_generate(data)
  end

  def log_data_found_locally
    p "Data found locally at #{@local_storage_path}"
  end

  def log_saved_locally
    p "Saved data locally to #{@local_storage_path}"
  end
end
