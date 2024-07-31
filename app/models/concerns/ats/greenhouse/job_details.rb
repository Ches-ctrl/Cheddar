module Ats
  module Greenhouse
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Constants

      def fetch_title_and_location(job_data)
        title = job_data['title']
        job_location = job_data.dig('location', 'name')
        [title, job_location]
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      def fetch_url(job_data, _company_id)
        job_data['absolute_url']
      end

      def job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/jobs/#{job_id}?questions=true&location_questions=true&demographic_questions=true&&compliance=true&pay_transparency=true"
      end

      def job_details(_job, data)
        title, location = fetch_title_and_location(data)
        {
          posting_url: data['absolute_url'],
          title:,
          description: Flipper.enabled?(:job_description) ? CGI.unescapeHTML(data['content']) : 'Not added yet',
          non_geocoded_location_string: location,
          department: data.dig('departments', 0, 'name'),
          office: data.dig('offices', 0, 'name'),
          date_posted: convert_from_iso8601(data['updated_at']),
          employment_type: fetch_employment_type(data) || 'Full-time',
          salary: fetch_salary(data)
        }
      end

      private

      def fetch_employment_type(data)
        default = 'Full-time'

        employment_type_custom_field = data['metadata']&.find { |field| field['name'] == "Employment Type" }
        string = employment_type_custom_field&.dig('value')
        return string || default
      end

      def fetch_salary(data)
        return unless (salary_data = data.dig('pay_input_ranges', 0))

        salary_low = number_with_delimiter(salary_data['min_cents'] / 100)
        salary_high = number_with_delimiter(salary_data['max_cents'] / 100)
        currency = salary_data['currency_type']
        symbol = CURRENCY_CONVERTER[currency&.downcase]&.first
        salary_low == salary_high ? "#{symbol}#{salary_low} #{currency}" : "#{symbol}#{salary_low} - #{symbol}#{salary_high} #{currency}"
      end
    end
  end
end
