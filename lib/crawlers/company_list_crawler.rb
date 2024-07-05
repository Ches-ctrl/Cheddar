require 'fileutils'
require 'csv'

module Crawlers
  class CompanyListCrawler
    OUTPUT_PATH = File.join(Rails.root, "storage/csv/crawl_list_output_#{Process.clock_gettime(Process::CLOCK_MONOTONIC).to_i}.csv")

    private

    # Allows for appending a row to an existing output file so as not to overwrite
    def dump_result(result_row)
      existing_rows = CSV.parse(File.read(OUTPUT_PATH), headers: true)
      headers = result_row.headers
      CSV.open(OUTPUT_PATH, 'w') do |csv|
        csv << headers
        existing_rows.each do |row|
          csv << row
        end
        csv << result_row
      end
    end

    public

    # Crawl company websites from the list for ats boards.
    #
    # `starting_offset` is 0-indexed, so if looking at the csv file,
    # substract 2 from the line number of where you want to start. (header row and 1-indexed)
    #
    # @param starting_offset [Integer]
    #
    # @param number_of_crawls [Integer]
    def crawl_list(starting_offset = 0, number_of_crawls = nil)
      company_list_path = File.join(Rails.root, "storage/csv/companies.csv")
      FileUtils.touch(OUTPUT_PATH)

      endex = number_of_crawls.nil? ? nil : starting_offset + number_of_crawls - 1
      data = CSV.parse(File.read(company_list_path), headers: true)[starting_offset..endex]
      max_crawl = 50
      max_time = 10
      max_hits = 1
      data.each do |row|
        crawler = Crawlers::CompanyCrawler.new(row["Website"])
        crawler.set_limits(max_crawl, max_time, max_hits)
        results = crawler.crawl
        hits = results.join("|")
        puts "Found #{results.length} hits."
        row<<{ "Hits"=>hits }
        dump_result(row)
      end
    end
  end
end
