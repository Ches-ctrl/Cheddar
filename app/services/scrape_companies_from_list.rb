class ScrapeCompaniesFromList
  include CompanyCsv

  def initialize
    puts "Importing companies from list..."
    @urls = load_from_csv('url_list')
    @companies = ats_list
  end

  def call
    @urls.each do |url|
      ats, ats_identifier = JobUrl.new(url).parse(@companies)
      next puts "couldn't find ats for url: #{url}" unless ats

      @companies[ats.name] << ats_identifier
    end

    puts "\nStoring the information in CSV format..."
    save_ats_list
  end
end
