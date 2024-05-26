module Ats
  module CompanyCreator
    extend ActiveSupport::Concern
    # TODO: Refactor this to simplify down

    def find_or_create_company_by_data(data)
      ats_identifier = fetch_company_id(data)
      find_or_create_company(ats_identifier, data)
    end

    def find_or_create_company(ats_identifier, data = nil)
      return unless ats_identifier

      company = Company.find_or_initialize_by(ats_identifier:) do |new_company|
        company_data = company_details(ats_identifier)

        new_company.applicant_tracking_system = self
        new_company.assign_attributes(company_data)
      end

      if data
        supplementary_data = company_details_from_data(data)
        company.assign_attributes(supplementary_data)
      end

      p "Company created - #{company.name}" if company.new_record? && company.save

      return company
    end

    def company_details(ats_identifier, data = nil)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    private

    def company_details_from_data(data)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def fetch_company_id(data)
      refer_to_module(defined?(super) ? super : nil, __method__)
    end

    def fetch_company_name(ats_identifier)
      url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{ats_identifier}"
      data = get_json_data(url)
      return data.dig(0, 'name') unless data.blank?
    end

    def fetch_total_live(ats_identifier)
      fetch_company_jobs(ats_identifier)&.count
    end
  end
end