# frozen_string_literal: true

class ApplicationTask
  def self.call(...)
    new(...).call
  end

  private

  def processable
    @data
  end

  def process
    select_transform_data
    log_and_return_data
  end

  def log_and_return_data
    output_file_path = Rails.root.join('public', output_file_name)
    File.write(output_file_path, select_transform_data.to_json)
    select_transform_data
  end
end
