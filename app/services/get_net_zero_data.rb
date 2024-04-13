class GetNetZeroData
  require 'net/http'
  require 'json'
  require 'csv'

  def self.perform
    url = URI("https://zerotracker.net/api/v1/companies")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      companies_data = []

      data.first(10).each do |company|
        company_url = URI(company['api_url'])
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
