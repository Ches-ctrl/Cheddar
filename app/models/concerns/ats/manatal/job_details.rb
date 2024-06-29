module Ats
  module Manatal
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['position_name']
        job_location = job_data['location_display']
        [title, job_location]
      end

      def fetch_id(job_data)
        job_data['hash']
      end

      def fetch_job_data(job_id, _api_url, ats_identifier)
        jobs = fetch_company_jobs(ats_identifier)
        jobs.find { |data| data["hash"] == job_id }
      end

      def job_url_api(base_url, company_id, _job_id)
        "#{base_url}#{company_id}/jobs/"
      end

      def job_details(job, data)
        title, location = fetch_title_and_location(data)
        {
          title:,
          description: Flipper.enabled?(:job_description) ? data['description'] : 'Not added yet',
          department: data['departmentLabel'],
          employment_type: data['contract_details'],
          non_geocoded_location_string: location,
          api_url: "#{job.api_url}#{data['id']}/",
          posting_url: "#{url_base}#{job.company.ats_identifier}/job/#{job.ats_job_id}/apply"
        }
      end

      # def build_location_string(data)
      #   locality = data['location_display']
      #   country = data['country']
      #   [locality, country].reject(&:blank?).join(', ')
      # end
    end
  end
end
