module Ats
  module Pinpointhq
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Constants

      private

      def fetch_job_data(job)
        # Move to main ATS model
        job_id = job.ats_job_id

        all_jobs_data = get_json_data(job.api_url)
        data = all_jobs_data["data"]&.find { |job| job["path"] == "/en/postings/#{job_id}" }

        return data if data

        # TODO: fix setup for when job posting is no longer live - at the moment will break the import

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
          description: build_description(data),
          salary: fetch_salary(data),
          employment_type: data['employment_type'].gsub('_', '-').capitalize,
          non_geocoded_location_string: build_location_string(data),
          department: data.dig('job', 'department', 'name'),
          requirements: data['skills_knowledge_requirements'],
          responsibilities: data['key_responsibilities'],
          benefits: data['benefits'],
          posting_url: data['url'],
          application_deadline: (Date.parse(data['deadline_at']) if data['deadline_at']),
          remote_only: data['workplace_type'] == 'remote',
          hybrid: data['workplace_type'] == 'hybrid'
        )
      end

      def build_description(data)
        [
          data['description'],
          ("<h2>#{data['key_responsibilities_header']}</h2>" if data['key_responsibilities_header']),
          data['key_responsibilities'],
          ("<h2>#{data['skills_knowledge_expertise_header']}</h2>" if data['skills_knowledge_expertise_header']),
          data['skills_knowledge_expertise'],
          ("<h2>#{data['benefits_header']}</h2>" if data['benefits_header']),
          data['benefits']
        ].reject(&:blank?).join
      end

      def build_location_string(data)
        [
          data.dig('location', 'city'),
          data.dig('location', 'province')
        ].reject(&:blank?).join(', ')
      end

      def fetch_salary(data)
        salary_low = number_with_delimiter(data['compensation_minimum'])
        salary_high = number_with_delimiter(data['compensation_maximum'])
        currency = data['compensation_currency']
        symbol = CURRENCY_CONVERTER[currency&.downcase]&.first
        salary_low == salary_high ? "#{symbol}#{salary_low} #{currency}" : "#{symbol}#{salary_low} - #{symbol}#{salary_high} #{currency}"
      end
    end
  end
end
