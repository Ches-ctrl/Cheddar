class ScrapeCompaniesFromList
  include CompanyCsv
  include AtsRouter
  include HashBuilder

  def initialize
    puts "Importing companies from list"
    @urls = load_from_csv('jobglob') + load_from_csv('linkup')
    @companies = build_ats_companies
  end

  def call
    @urls.each do |url|
      @url = url

      next unless (company = ats_identifier)

      ats = ats_system_name.to_sym
      @companies[ats] << company
    end

    puts "\nStoring the information in CSV format..."

    @companies.each do |ats_name, list|
      write_to_csv(ats_name.to_s, list)
    end
  end
end
