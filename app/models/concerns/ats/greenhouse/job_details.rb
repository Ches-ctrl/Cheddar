module Ats
  module Greenhouse
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Constants

      private

      def fetch_title_and_location(job_data)
        job_title = job_data['title']
        job_location = job_data.dig('location', 'name')
        [job_title, job_location]
      end

      def fetch_url(job_data)
        job_data['absolute_url']
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      def job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/jobs/#{job_id}?questions=true&pay_transparency=true"
      end

      def job_details(job, data)
        job.assign_attributes(
          job_posting_url: data['absolute_url'],
          job_title: data['title'],
          job_description: data['content'],
          non_geocoded_location_string: data.dig('location', 'name'),
          department: data.dig('departments', 0, 'name'),
          office: data.dig('offices', 0, 'name'),
          date_created: convert_from_iso8601(data['updated_at']),
          employment_type: fetch_employment_type(data) || 'Full-time',
          salary: fetch_salary(data)
        )
      end

      def fetch_employment_type(data)
        employment_type_custom_field = data['metadata']&.find { |field| field['name'] == "Employment Type" }
        employment_type_custom_field&.dig('value')&.capitalize
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
