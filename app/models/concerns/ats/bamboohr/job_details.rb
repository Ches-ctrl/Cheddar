module Ats
  module Bamboohr
    module JobDetails
      include Relevant

      def fetch_title_and_location(job_data)
        title = job_data['jobOpeningName']
        job_location = build_location_string(job_data)
        remote = job_remote?(job_data) || job_data.dig('location', 'addressCountry').nil?
        [title, job_location, remote]
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      private

      def job_details(job, data)
        title, location = fetch_title_and_location(data)
        job.assign_attributes(
          title:,
          description: data['description'],
          salary: data['compensation'],
          date_posted: (Date.parse(data['datePosted']) if data['datePosted']),
          seniority: data['minimumExperience'], # seniority_standardizer will need to fix this!
          department: data['departmentLabel'],
          employment_type: data['employmentStatusLabel'],
          remote: job_remote?(data),
          hybrid: job_hybrid?(data),
          non_geocoded_location_string: location,
          posting_url: "#{url_base.sub('XXX', job.company.ats_identifier)}#{data['id']}",
          live: data['jobOpeningStatus'] == 'Open'
        )
      end

      def job_url_api(_base_url, ats_identifier, job_id)
        company = Company.find_by(ats_identifier:)
        "#{company.url_ats_main}#{job_id}/detail"
      end

      def fetch_job_data(job)
        # Check relevancy again with the full location data
        # If not relevant, scuttle job creation by returning nil
        data = get_json_data(job.api_url)&.dig('result', 'jobOpening')
        p data
        details = fetch_title_and_location(data)
        p details
        relevant?(*details) ? data : nil
      end

      def job_remote?(data)
        data['locationType'] == '1'
      end

      def job_hybrid?(data)
        data['locationType'] == '2'
      end

      def build_location_string(data)
        [
          data.dig('location', 'city'),
          data.dig('location', 'state'),
          data.dig('location', 'postalCode'),
          data.dig('location', 'addressCountry')
        ].reject(&:blank?).join(', ')
      end
    end
  end
end
