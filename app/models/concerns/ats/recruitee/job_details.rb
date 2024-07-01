module Ats
  module Recruitee
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Constants

      def fetch_title_and_location(job_data)
        title = job_data['title']
        location = build_location_string(job_data)
        [title, location]
      end

      def fetch_id(job_data)
        job_data['slug']
      end

      def fetch_job_data(job_id, api_url, _ats_identifier)
        all_jobs_data = get_json_data(api_url)
        apply_url = fetch_apply_url(api_url, job_id)
        all_jobs_data["offers"]&.find { |job_data| job_data["careers_apply_url"] == apply_url }
      end

      def job_url_api(_base_url, ats_identifier, _job_id)
        company = Company.find_by(ats_identifier:)
        company.url_ats_api
      end

      def job_details(job, data)
        title, location = fetch_title_and_location(data)
        {
          title:,
          requirements: data['requirements'],
          description: Flipper.enabled?(:job_description) ? [data['description'], data['requirements']].reject(&:blank?).join : 'Not added yet',
          salary: fetch_salary(data),
          department: data['department'],
          employment_type: fetch_employment_type(data),
          non_geocoded_location_string: location,
          posting_url: data['careers_apply_url'],
          apply_url: fetch_apply_url(job.api_url, job.ats_job_id),
          date_posted: (Date.parse(data['updated_at']) if data['updated_at']),
          seniority: fetch_seniority(data),
          # req_cv: data['options_cv'] == 'required',
          # req_cover_letter: data['options_cover_letter'] == 'required',
          remote: data['remote'],
          hybrid: data['hybrid']
        }
      end

      private

      def fetch_apply_url(api_url, job_id)
        api_url.sub('api/offers/', "o/#{job_id}/c/new")
      end

      def build_location_string(data)
        locations = data['locations']&.map do |location|
          city = location['city'] || location['name']
          state = location['state']
          country = location['country']
          [city, state, country].reject(&:blank?).join(', ')
        end
        locations.reject(&:blank?).join(' && ')
      end

      def fetch_employment_type(data)
        # TODO: confirm whether these codes are standardized or not

        convert = {
          'fulltime' => 'Full-time',
          'fulltime_permanent' => 'Full-time',
          'parttime' => 'Part-time',
          'contract' => 'Contract'
        }
        code = data['employment_type_code']
        convert[code]
      end

      def fetch_seniority(data)
        string = data['experience_code']
        SENIORITY_TITLES.each do |keyword, level|
          return level if string.match?(keyword)
        end
        return nil
      end

      def fetch_salary(data)
        return unless data.dig('salary', 'min')

        salary_low = number_with_delimiter(data.dig('salary', 'min'))
        salary_high = number_with_delimiter(data.dig('salary', 'max'))
        currency = data.dig('salary', 'currency')
        symbol = CURRENCY_CONVERTER[currency&.downcase]&.first
        salary_low == salary_high ? "#{symbol}#{salary_low} #{currency}" : "#{symbol}#{salary_low} - #{symbol}#{salary_high} #{currency}"
      end
    end
  end
end
