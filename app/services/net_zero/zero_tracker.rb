class ZeroTracker
  require 'net/http'
  require 'json'
  require 'csv'

  # Approaches - build Net Zero data once and then save it in the format we need and then read from that file
  # Or build the data when creating the job and company
  # Do all or a subset of the company data from the API?
  # Also need to match this against the company data from the other APIs - EUNZDP, SBTi and the manual data
  # De-duping is a problem
  # How to uniquely identify a company?
  # Correct structure for this - net zero class with sub-modules that get called sequentially?
  # Make sure it's all wrapped in a background job so that it doesn't stress the server
  # Mock the API calls for testing
  # Error handling - what to do if the API call fails?
  # Monitoring source of the data so that we can check which database is most useful and where it's coming from
  # How to handle the data - store it in the database or just in a CSV file?
  # Do we need models for the Net Zero data providers?
  # Need to create a unique identifier for each company so that it gets the correct data from the APIs
  # Probably pull all the data from the APIs and store as CSV so we know what we have
  # Frequency to update this on? Do we need to update this data regularly? Probably monthly/yearly?
  # UpdateExistingNetZeroDataJob - to update the data for the companies that already exist in the database
  # Need to make sure everything is harmonised in terms of the different structures
  # Likely that there are company repetitions across the various sources
  # Display this data in a separate page using a standard DB structure as well as chartjs
  # Assigning industry and sub-industry to the companies is a question

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
