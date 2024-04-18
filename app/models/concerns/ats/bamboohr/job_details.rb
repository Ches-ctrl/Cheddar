module Ats
  module Bamboohr
    module JobDetails
      def fetch_job_data(job)
        job_id = job.ats_job_id

        response = get(job.api_url)
        all_jobs_data = JSON.parse(response)
        data = all_jobs_data["result"].find { |job| job["id"] == job_id }

        return data if data

        p "Job with ID #{job_id} is expired."
        job.live = false
        return nil
      end

      def job_details(job, data)
        location = "#{data.dig('location', 'city')}, #{data['location', 'state']}" if data['location', 'city'] && data['location', 'state']

        job.assign_attributes(
          job_title: data['jobOpeningName'],
          department: data['departmentLabel'],
          employment_type: data['employmentStatusLabel'],
          # location:,
          ats_job_id: data['id']
        )
      end

      def job_url_api(_base_url, company_id, _job_id)
        company = Company.find(company_id)
        company.url_ats_api
      end

      def fetch_location_string(data)
        locality = data.dig('address', 'postalAddress', 'addressLocality')
        country = data.dig('address', 'postalAddress', 'addressCountry')
        [locality, country].compact.join(', ')
      end
    end
  end
end
