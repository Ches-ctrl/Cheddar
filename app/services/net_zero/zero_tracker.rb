module NetZero
  class ZeroTracker
    require 'net/http'

    # Pseudocode
    # Setup models for the Net Zero data providers
    # Setup a main class that calls each scraper module as a sub-class
    # Get all companies from each API to see what data is available
    # Sources: Zero Tracker, EUNZDP, SBTi, manual data
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

    def self.perform
      url = URI("https://zerotracker.net/api/v1/companies")
      response = Net::HTTP.get_response(url)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        companies_data = []

        data.first(10).each do |company|
          company_url = URI(company['api_url'])
          p company_url
          company_response = Net::HTTP.get_response(company_url)

          if company_response.is_a?(Net::HTTPSuccess)
            company_data = JSON.parse(company_response.body)
            p company_data
            companies_data << company_data
          else
            puts "Failed to retrieve data for #{company['name']}. Error: #{company_response.code} - #{company_response.message}"
          end
        end

        p "save"
        save_to_csv(companies_data)
      else
        puts "Failed to retrieve net zero data. Error: #{response.code} - #{response.message}"
      end
    end

    def self.save_to_csv(data)
      CSV.open("storage/csv/net_zero_data.csv", "wb") do |csv|
        csv << data.first.keys
        data.each do |company|
          csv << company.values
        end
      end
      puts "Data saved to net_zero_data.csv"
    end
  end
end
