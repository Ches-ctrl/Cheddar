module Ats
  module CompanyCreator
    extend ActiveSupport::Concern
    # TODO: Refactor this to simplify down
    # TODO: Refactor into a service object according to the Single Responsibility Principle

    def company_details(ats_identifier, data = nil)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def company_details_from_data(data)
      data
    end

    def fetch_company_id(data)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    private

    def fetch_company_name(ats_identifier)
      p "Fetching company name from clearbit"
      url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
      data = get_json_data(url)
      return data.dig(0, 'name') unless data.blank?
    end

    def fetch_total_live(ats_identifier)
      fetch_company_jobs(ats_identifier)&.count
    end
  end
end
