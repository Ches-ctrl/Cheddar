module CsvFiles
  class SortCsv
    def sort_ats_identifiers
      csv_data = read_csv('storage/csv/ats_identifiers.csv')
      return unless csv_data

      sorted_data = sort_csv_data(csv_data, %w[ats ats_identifier])
      write_csv('storage/csv/ats_identifiers.csv', sorted_data, %w[ats ats_identifier])

      puts "ATS identifiers CSV file sorted successfully."
    end

    def sort_company_urls
      csv_data = read_csv('storage/new/company_urls.csv')
      return unless csv_data

      sorted_data = csv_data.sort_by { |row| row['company_url'] }
      write_csv('storage/new/company_urls.csv', sorted_data, ['company_url'])

      puts "Company URLs CSV file sorted successfully."
    end

    def sort_job_urls
      csv_data = read_csv('storage/new/job_posting_urls.csv')
      return unless csv_data

      sorted_data = csv_data.sort_by { |row| row['posting_url'] }
      write_csv('storage/new/job_posting_urls.csv', sorted_data, ['posting_url'])

      puts "Job posting URLs CSV file sorted successfully."
    end

    private

    def read_csv(file_path)
      CSV.read(file_path, headers: true)
    rescue StandardError => e
      puts "Error reading CSV file #{file_path}: #{e.message}"
      nil
    end

    def sort_csv_data(csv_data, headers)
      csv_data.sort_by(&:to_s).map { |row| row.to_h.values_at(*headers) }
    end

    def write_csv(file_path, data, headers)
      CSV.open(file_path, 'w', write_headers: true, headers:) do |csv|
        data.each { |row| csv << row }
      end
    rescue StandardError => e
      puts "Error writing to CSV file #{file_path}: #{e.message}"
    end
  end
end
