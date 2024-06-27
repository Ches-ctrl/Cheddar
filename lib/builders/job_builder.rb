module Builders
  class JobBuilder
    def build
      Company.all.each do |company|
        CompanyJobsFetcher.new(company).call
      rescue StandardError => e
        puts "Error: #{e}"
      end
    end
  end
end
