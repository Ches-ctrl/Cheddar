module NetZeroData
  class NetZeroApi
    require 'net/http'

    # TODO: Build companies based on list given and add to core company DB

    # Notes:
    # List of Net Zero Data Sources: Zero Tracker, EU NZDP, SBTi, CDP, manual data (in order of priority)
    # Think we should match companies so that they're unique based on their ISIN (prevents likely duplication across multiple sources)
    # Note: SBTi, CDP and manual data do not have public APIs so must be built from CSVs
    # Note: GCAP (UNFCCC) is a wrapper on the CDP dataset (could be scraped but limited info available)

    # To do later:
    # Mock the API calls for testing
    # Error handling - what to do if the API call fails?
    # Monitoring source of the data to see % allocation
    # Setup background job to update quarterly (UpdateExistingNetZeroDataJob)
    # Display this data in a separate page using a standard DB structure as well as chartjs

    # Questions:
    # Assigning industry and sub-industry to the companies?

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
      puts "Number of companies: #{no_of_companies}"
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
      self.name.demodulize # rubocop:disable Style/RedundantSelf
    end

    def self.date
      Time.now.strftime('%Y-%m-%d')
    end
  end
end
