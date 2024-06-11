require_relative 'company_crawler'
require 'pathname'
require 'fileutils'
require 'csv'

ROOT = Pathname.new(__FILE__).parent.parent.parent.parent

company_list_path = ROOT + "companies.csv" # rubocop:disable Style/StringConcatenation
OUTPUT_PATH = Pathname.new("crawl_list_output.csv")
FileUtils.touch(OUTPUT_PATH)

# Allows for appending a row to an existing output file so as not to overwrite
# This also means that if you recrawl a company, it'll have more than one entry in the output file
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

data = CSV.parse(File.read(company_list_path), headers: true)
max_crawl = 50
max_time = 10
max_hits = 1
data.each do |row|
  crawler = CompanyCrawler.new(row["Website"])
  results = crawler.crawl(max_crawl, max_time, max_hits)
  hits = results.join("|")
  puts "Found #{results.length} hits."
  row<<{ "Hits"=>hits }
  dump_result(row)
end
