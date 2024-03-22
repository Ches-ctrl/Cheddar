module CompanyCsv
  extend ActiveSupport::Concern
  include Constants

  def ats_list
    list = Hash.new { |hash, key| hash[key] = Set.new }

    CSV.foreach(db_filepath) do |ats_name, ats_identifier|
      list[ats_name] << ats_identifier
    end
    list
  end

  def save_ats_list
    CSV.open(db_filepath, 'wb') do |csv|
      @companies.each do |ats_name, list|
        list.each do |ats_id|
          csv << [ats_name, ats_id]
        end
      end
    end
  end

  def load_from_csv(file_name, filepath = nil)
    company_list = Set.new
    filepath ||= list_filepath(file_name)

    CSV.foreach(filepath) do |row|
      company_list << row[0]
    end
    company_list
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
end
