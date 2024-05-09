module NetZeroData
  class ZeroTracker < NetZeroApi
    BASE_URL = "https://zerotracker.net/api/v1/companies"

    def self.build_all_data
      super(BASE_URL)
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
  end
end
