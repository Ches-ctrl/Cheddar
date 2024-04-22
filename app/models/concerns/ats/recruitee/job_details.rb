module Ats
  module Recruitee
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Constants

      private

      def fetch_job_data(job)
        job_apply_url = "#{job.company.url_ats_main}o/#{job.ats_job_id}/c/new"

        all_jobs_data = get_json_data(job.api_url)
        data = all_jobs_data["offers"].find { |job| job["careers_apply_url"] == job_apply_url }

        return data if data

        p "Job with ID #{job.ats_job_id} is expired."
        job.live = false
        return nil
      end

      def job_url_api(_base_url, ats_identifier, _job_id)
        company = Company.find_by(ats_identifier:)
        company.url_ats_api
      end

      def job_details(job, data)
        job.assign_attributes(
          title: data['title'],
          requirements: data['requirements'],
          description: [data['description'], data['requirements']].reject(&:blank?).join,
          salary: fetch_salary(data),
          department: data['department'],
          employment_type: fetch_employment_type(data),
          non_geocoded_location_string: fetch_location(data),
          posting_url: data['careers_apply_url'],
          date_posted: (Date.parse(data['updated_at']) if data['updated_at']),
          seniority: fetch_seniority(data),
          req_cv: data['options_cv'] == 'required',
          req_cover_letter: data['options_cover_letter'] == 'required',
          remote_only: data['remote'],
          hybrid: data['hybrid']
        )
      end

      def fetch_location(data)
        location = data['location']
        location == 'Remote job' ? data.dig('locations', 0, 'country') : location
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
