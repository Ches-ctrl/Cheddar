module CompanyCsv
  extend ActiveSupport::Concern

  def load_from_csv(ats_name)
    company_list = Set.new
    filepath = get_filename(ats_name)

    CSV.foreach(filepath) do |row|
      company_list << row[0]
    end
    company_list
  end

  def write_to_csv(ats_name, list)
    filepath = get_filename(ats_name)

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
end
