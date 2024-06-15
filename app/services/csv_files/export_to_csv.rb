module CsvFiles
  class ExportToCsv
    # TODO: Add support for filtering list of jobs by criteria

    def initialize(record_type, filters = {})
      @record_type = record_type
      @records = apply_filters(record_type, filters)
      @attributes = record_type.column_names
      @record_type_name = record_type.to_s.downcase.pluralize
    end

    def to_csv
      current_date = Time.zone.now.strftime('%Y-%m-%d')
      file_name = generate_file_name(current_date)

      create_directory_if_not_exists(file_name)
      write_csv(file_name)

      puts "CSV file for #{@record_type_name} generated: #{file_name}"
      file_name
    end

    private

    def apply_filters(record_type, filters)
      query = record_type.all
      filters.each do |key, value|
        query = query.where(key => value) if record_type.column_names.include?(key.to_s)
      end
      query
    end

    def generate_file_name(current_date)
      Rails.root.join('storage', 'csv', "#{current_date}-#{@record_type_name}.csv")
    end

    def create_directory_if_not_exists(file_name)
      file_directory = File.dirname(file_name)
      FileUtils.mkdir_p(file_directory) unless File.directory?(file_directory)
    end

    def write_csv(file_name)
      CSV.open(file_name, 'wb') do |csv|
        csv << @attributes
        @records.each { |record| csv << @attributes.map { |attr| record.send(attr) } }
      end
    rescue StandardError => e
      puts "Error writing CSV file #{file_name}: #{e.message}"
    end
  end
end
