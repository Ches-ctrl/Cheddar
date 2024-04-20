module AtsUrlIdentifiers
  extend ActiveSupport::Concern
  include Constants

  # Isn't this basically the same as determine_ats in applicant_tracking_system.rb?
  def match_ats(url)
    ats_hash.each do |regex, ats_name|
      return ApplicantTrackingSystem.find_by(name: ats_name) if url.match?(regex)
    end
    return false
  end

  def ats_hash
    csv_filepath = Rails.root.join('storage', 'csv', 'ats_systems.csv')
    ats_list = CSV.read(csv_filepath, headers: :first_row, header_converters: :symbol)
    ats_hash = ATS_SYSTEM_PARSER # include alternate identifiers
    ats_list.each { |row| ats_hash[/\b#{Regexp.escape(row[:url_identifier])}\b/] = row[:ats_name] }
    ats_hash
  end
end
