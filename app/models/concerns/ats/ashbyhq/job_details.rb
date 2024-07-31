module Ats
  module Ashbyhq
    module JobDetails
      # AshbyHQ has a single API endpoint per company for all jobs.

      def fetch_title_and_location(job_data)
        title = job_data['title']
        job_location = job_data['location']
        [title, job_location]
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      def job_url_api(url_api, ats_identifier, _job_id)
        "#{url_api}#{ats_identifier}?includeCompensation=true"
      end

      def fetch_url(job_data, _company_id)
        job_data['jobUrl']
      end

      def fetch_job_data(job_id, api_url, _ats_identifier)
        all_jobs_data = get_json_data(api_url)
        all_jobs_data["jobs"]&.find { |job| job["id"] == job_id }
      end

      def job_details(_job, data)
        title, location = fetch_title_and_location(data)
        {
          title:,
          description: Flipper.enabled?(:job_description) ? data['descriptionHtml'] : 'Not added yet',
          non_geocoded_location_string: location,
          department: data['department'],
          posting_url: data['jobUrl'],
          apply_url: data['applyUrl'],
          employment_type: data['employmentType'],
          # deadline: data['applicationDeadline'],
          salary: data.dig('compensation', 'compensationTierSummary'), # more info available
          remote: data['isRemote']
        }
      end
    end
  end
end
