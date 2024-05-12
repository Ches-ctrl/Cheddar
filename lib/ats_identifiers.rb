class AtsIdentifiers
  LIST_FILEPATH = Rails.root.join('storage', 'csv', 'ats_identifiers.csv')

  def self.load
    company_list = Hash.new { |hash, key| hash[key] = Set.new }

    CSV.foreach(LIST_FILEPATH) do |ats_name, ats_identifier|
      company_list[ats_name] << ats_identifier
    end
    company_list
  end

  def self.save(fulllist)
    CSV.open(LIST_FILEPATH, 'wb') do |csv|
      fulllist.each do |ats_name, ats_list|
        ats_list.each do |ats_id|
          csv << [ats_name, ats_id]
        end
      end
    end
  end
end
