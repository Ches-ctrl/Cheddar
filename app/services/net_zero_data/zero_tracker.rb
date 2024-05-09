module NetZeroData
  class ZeroTracker
    require 'net/http'

    # Pseudocode
    # 1. Get all companies
    # 2. Get data for each company
    # 3. Take out relevant data
    # 4. Save data to CSV

    # TODO: Save endpoint at which the data is collected

    BASE_URL = "https://zerotracker.net/api/v1/companies"

    def self.build_all_data
      url = URI(BASE_URL)
      companies_data = fetch_json_data(url)

      no_of_companies = companies_data.count
      p "Number of companies: #{no_of_companies}"

      relevant_data = companies_data.first(100).map do |company|
        company_url = get_company_endpoint(company)
        company_data = fetch_json_data(company_url)
        pull_out_relevant_data(company_data)
      end
      save_to_csv(relevant_data)
    end

    def self.fetch_json_data(url)
      # TODO: write a helper method for fetching json or use Dan's (once reviewed/understood retry behaviour) as we do this alllllll the time
      response = Net::HTTP.get_response(url)
      JSON.parse(response.body)
    rescue StandardError => e
      puts "Failed to retrieve net zero data from companies endpoint. Error: #{e.message}"
    end

    def self.get_company_endpoint(company)
      URI(company['api_url'])
    end

    def self.pull_out_relevant_data(company)
      {
        last_updated: company['last_updated'], # To add
        website: company['website'], # To remove at a later date # TODO: change to HTTPS
        data_source: 'Zero Tracker',
        ox_id_code: company['id_code'],
        gcap_id: company['gcap_id'], # To add
        name: company['name'],
        isin_id: company['isin_id'],
        race_to_zero: company['race_to_zero_member'] == 'Yes',
        final_target: company['end_target'],
        final_target_year: company['end_target_year'],
        final_target_status: company['end_target_status'], # To remove
        status_date: company['status_date'], # To remove
        interim_target: company['interim_target'],
        interim_target_year: company['interim_target_year'],
        scope_1: company['scope_1'] == 'Yes',
        scope_2: company['scope_2'] == 'Yes',
        scope_3: company['scope_3'] == 'Yes',
        source_url: company['source_url'],
        industry: company['industry']
      }
    end

    def self.save_to_csv(data)
      CSV.open("storage/net_zero_data/zerotracker.csv", "wb") do |csv|
        csv << data.first.keys
        data.each do |company|
          csv << company.values
        end
      end
      puts "Data saved to net_zero_data.csv"
    end
  end
end
