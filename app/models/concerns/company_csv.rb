module CompanyCsv
  extend ActiveSupport::Concern
  include Constants

  def ats_list
    load_from_csv('ats_identifiers')
  end

  def save_ats_list(ats_list, filename = 'ats_identifiers')
    filepath = list_filepath(filename)
    headers = fetch_headers(filepath)
    CSV.open(filepath, 'wb', write_headers: true, headers:) do |csv|
      ats_list.each do |ats_name, list|
        list.each do |ats_id|
          csv << [ats_name, ats_id]
        end
      end
    end
  end

  def load_from_csv(file_name, filepath = nil)
    company_list = ats_hash
    filepath ||= list_filepath(file_name)

    CSV.foreach(filepath, headers: :first_row, header_converters: :symbol) do |row|
      ats_name, ats_identifier = row.values_at(:ats_name, :ats_identifier)
      company_list[ats_name].add(ats_identifier)
    end
    company_list
  end

  def ats_hash
    Hash.new { |hash, key| hash[key] = Set.new }
  end

  # def write_to_csv(ats_name, list, filepath = nil)
  #   filepath ||= list_filepath(ats_name)

  #   CSV.open(filepath, 'wb') do |csv|
  #     list.each do |record|
  #       csv << [record]
  #     end
  #   end
  # end

  private

  def list_filepath(filename)
    return "#{file_directory}/#{filename}.csv"
  end

  def db_filepath
    return "#{file_directory}/ats_identifiers.csv"
  end

  def file_directory
    directory = Rails.root.join('storage', 'csv')
    FileUtils.mkdir_p(directory) unless File.directory?(directory)
    directory
  end

  def fetch_headers(filepath)
    existing_headers = []
    CSV.foreach(filepath, headers: :first_row, header_converters: :symbol) do |row|
      existing_headers = row.headers
      break
    end
    existing_headers
  end
end
