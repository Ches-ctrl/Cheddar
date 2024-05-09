module NetZeroData
  class EuNzdpu < NetZeroApi
    BASE_URL = "https://nzdpu.com/wis/coverage/companies"

    # This isn't yet setup as the API doesn't really give us the data we need. There are also only ~380 companies in the database which doesn't feel hugely worth the de-duping/matching effort.
    # Note that the data on companies will need to be passed as all the company reference data is on the main /companies endpoint rather than the /targets endpoint.
    # TODO: Complete build out if we decide this is worth it. This list may be completely covered by the Oxford dataset.

    def self.build_all_data
      super(BASE_URL)
    end

    def self.get_company_endpoint(company)
      lei = company['lei']
      url = "#{BASE_URL}/#{lei}/targets"
      URI(url)
    end

    def self.pull_out_relevant_data(company)
      {
        data_source: 'EU NZDPU',
        # eunzdp_lei:, # To add
      }
    end
  end
end
