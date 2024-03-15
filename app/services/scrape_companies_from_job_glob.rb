class ScrapeCompaniesFromJobGlob
  include CompanyCsv
  include AtsRouter

  def initialize
    puts "Importing companies from jobglob"
    @urls = load_from_csv('jobglob')
    @companies = {
      greenhouse: load_from_csv('greenhouse'),
      lever: load_from_csv('lever'),
      workable: load_from_csv('workable'),
      ashbyhq: load_from_csv('ashbyhq'),
      pinpointhq: load_from_csv('pinpointhq'),
      bamboohr: load_from_csv('bamboohr'),
      recruitee: load_from_csv('recruitee'),
      manatal: load_from_csv('manatal'),
    }
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
