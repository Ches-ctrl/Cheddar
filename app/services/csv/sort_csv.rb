module Csv
  class SortCsv
    def sort_ats_identifiers
      csv_data = CSV.read('storage/csv/ats_identifiers.csv', headers: true)
      p csv_data.length

      rows_as_strings = csv_data.map(&:to_s)
      rows_as_strings.map! { |row| row.gsub("\n", "") }
      sorted_data = rows_as_strings.sort

      CSV.open('storage/csv/ats_identifiers.csv', 'w', write_headers: true, headers: ['ats', 'ats_identifier']) do |csv|
        sorted_data.each { |row| csv << row.split(',') }
      end

      puts "CSV file sorted successfully."
    end

    def sort_company_urls
      csv = CSV.read('storage/new/company_urls.csv', headers: true)
      sorted = csv.sort_by { |row| row['company_url'] }

      CSV.open('storage/new/company_urls.csv', 'w') do |csv|
        csv << ['company_url']
        sorted.each { |row| csv << [row['company_url']] }
      end
    end
  end
end
