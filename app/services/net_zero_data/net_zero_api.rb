module NetZeroData
  class NetZeroApi
    require 'net/http'

    def self.build_all_data(base_url)
      url = URI(base_url)
      companies_data = fetch_json_data(url)
      company_count(companies_data)

      relevant_data = companies_data.first(10).map do |company|
        company_url = get_company_endpoint(company)
        company_data = fetch_json_data(company_url)
        pull_out_relevant_data(company_data)
      end
      class_name
      save_to_csv(relevant_data)
    end

    def self.fetch_json_data(url)
      # TODO: write a helper method for fetching json or use Dan's (once reviewed/understood retry behaviour) as we do this alllllll the time
      response = Net::HTTP.get_response(url)
      JSON.parse(response.body)
    rescue StandardError => e
      puts "Failed to retrieve net zero data from companies endpoint. Error: #{e.message}"
    end

    def self.company_count(companies_data)
      no_of_companies = companies_data.count
      p "Number of companies: #{no_of_companies}"
    end

    def self.save_to_csv(data)
      csv_name = "#{date}-#{class_name}"
      CSV.open("storage/net_zero_data/#{csv_name}.csv", "wb") do |csv|
        csv << data.first.keys
        data.each do |company|
          csv << company.values
        end
      end
      puts "Data saved to #{csv_name}"
    end

    def self.class_name
      self.name.demodulize
    end

    def self.date
      Time.now.strftime('%Y-%m-%d')
    end
  end
end

# Pseudocode
# Setup models for the Net Zero data providers
# Setup a main class that calls each scraper module as a sub-class
# Get all companies from each API to see what data is available
# Sources: Zero Tracker, EUNZDP, SBTi, CDP, manual data
# Note: SBTi & CDP do not have public APIs
# Note: GCAP (UNFCCC) is a wrapper on the CDP dataset
# Setup a background job that calls the service class

# Later
# Mock the API calls for testing
# Error handling - what to do if the API call fails?
# Monitoring source of the data to see % allocation
# Setup background job to update quarterly (UpdateExistingNetZeroDataJob)
# Display this data in a separate page using a standard DB structure as well as chartjs

# Notes
# Likely that there are company repetitions across the various sources

# Questions
# Need to create a unique identifier for each company so that it gets the correct data from the APIs?
# How to de-dupe companies?
# How to uniquely identify a company?
# Assigning industry and sub-industry to the companies?
