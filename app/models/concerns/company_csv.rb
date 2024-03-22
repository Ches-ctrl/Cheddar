module CompanyCsv
  extend ActiveSupport::Concern
  include Constants

  def ats_list
    list = Hash.new { |hash, key| hash[key] = Set.new }

    CSV.foreach(list_filepath) do |ats_name, ats_identifier|
      list[ats_name] << ats_identifier
    end
    list
  end

  def save_ats_list
    CSV.open(list_filepath, 'wb') do |csv|
      @companies.each do |ats_name, list|
        list.each do |ats_id|
          csv << [ats_name, ats_id]
        end
      end
    end
  end

  def load_from_csv(ats_name, filepath = nil)
    company_list = Set.new
    filepath ||= get_filename(ats_name)

    CSV.foreach(filepath) do |row|
      company_list << row[0]
    end
    company_list
  end

  def write_to_csv(ats_name, list, filepath = nil)
    filepath ||= get_filename(ats_name)

    CSV.open(filepath, 'wb') do |csv|
      list.each do |record|
        csv << [record]
      end
    end
  end

  private

  def get_filename(ats_name)
    file_directory = Rails.root.join('storage', 'csv')
    FileUtils.mkdir_p(file_directory) unless File.directory?(file_directory)
    return "#{file_directory}/#{ats_name}_companies.csv"
  end

  def list_filepath
    file_directory = Rails.root.join('storage', 'csv')
    FileUtils.mkdir_p(file_directory) unless File.directory?(file_directory)
    return "#{file_directory}/ats_identifiers.csv"
  end
end
