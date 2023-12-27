class ExportData
  def initialize(record_type)
    @records = record_type.all
    @attributes = record_type.column_names
    @record_type = record_type.to_s.downcase.pluralize
  end

  def to_csv
    current_date = Time.zone.now.strftime('%Y-%m-%d')
    p current_date

    file_directory = Rails.root.join('storage', 'csv')
    FileUtils.mkdir_p(file_directory) unless File.directory?(file_directory)
    file_name = "#{file_directory}/#{current_date}-#{@record_type}.csv"

    # file_name = "#{current_date}-#{@record_type}.csv"
    p file_name

    CSV.open(file_name, 'wb') do |csv|
      csv << @attributes

      @records.each do |record|
        csv << @attributes.map { |attr| record.send(attr) }
      end
    end

    p "CSV file for #{@record_type} generated: #{file_name}"
    file_name
  end
end
