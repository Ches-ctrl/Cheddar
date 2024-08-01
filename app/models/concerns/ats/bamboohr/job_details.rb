module Ats
  module Bamboohr
    module JobDetails
      include Relevant

      def fetch_title_and_location(job_data)
        # This method is called with job_data from company endpoint, which gives limited
        # location info; simple_standardize ensures that location includes a country for
        # purposes of determining whether job is relevant.
        title = job_data['jobOpeningName']
        location_string = build_location_string(job_data)
        location = Standardizer::LocationStandardizer.new('').simple_standardize(location_string)
        [title, location]
      end

      def fetch_id(job_data)
        p "Fetching ID: #{job_data['id']}"
        job_data['id']
      end

      def fetch_posting_url(job_data, company_id)
        url_base.sub('XXX', company_id) + job_data['id']
      end

      def job_url_api(_base_url, ats_identifier, job_id)
        company = Company.find_by(ats_identifier:)
        "#{company.url_ats_main}#{job_id}/detail"
      end

      def fetch_job_data(_job_id, api_url, _ats_identifier)
        get_json_data(api_url)&.dig('result')
      end

      def job_details(_job, data)
        data = data['jobOpening']
        {
          title: data['jobOpeningName'],
          description: Flipper.enabled?(:job_description) ? data['description'] : 'Not added yet',
          salary: data['compensation'],
          date_posted: (Date.parse(data['datePosted']) if data['datePosted']),
          seniority: data['minimumExperience'], # seniority_standardizer will need to fix this!
          department: data['departmentLabel'],
          employment_type: data['employmentStatusLabel'],
          remote: job_remote?(data),
          hybrid: job_hybrid?(data),
          non_geocoded_location_string: build_location_string(data),
          posting_url: data['jobOpeningShareUrl'],
          live: data['jobOpeningStatus'] == 'Open'
        }
      end

      private

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
