module Ats
  module Workday
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['name']
        location = fetch_location(job_data)
        [title, location]
      end

      def fetch_id(job_data)
        path = job_data['externalPath']
        path.split('/').last(2).join('/')
      end

      private

      def job_url_api(_base_url, ats_identifier, job_id)
        base = fetch_base_url(ats_identifier)
        "#{base}job/#{job_id}"
      end

      def job_details(job, data)
        title, location = fetch_title_and_location(data)
        job.assign_attributes(
          title:,
          description: Flipper.enabled?(:job_description) ? build_description(data.dig('jobAd', 'sections')) : 'Not added yet',
          posting_url: data['applyUrl'],
          remote: remote?(data),
          non_geocoded_location_string: location,
          seniority: fetch_seniority(data),
          department: data.dig('department', 'label'),
          requirements: data.dig('jobAd', 'sections', 'qualifications', 'text'),
          date_posted: (Date.parse(data['releasedDate']) if data['releasedDate']),
          industry: data.dig('industry', 'label'),
          employment_type: data.dig('typeOfEmployment', 'label')
        )
      end

      def fetch_location(data)
        country_custom_field = data['customField']&.find { |field| field['fieldId'] == "COUNTRY" }
        country_string = country_custom_field&.dig('valueLabel')

        if remote?(data)
          country_string
        else
          [data.dig('location', 'city'), country_string].reject(&:blank?).join(', ')
        end
      end

      def remote?(data)
        data.dig('location', 'remote')
      end

      def fetch_seniority(data)
        convert = {
          'entry_level' => 'Entry-Level',
          'associate' => 'Junior',
          'internship' => 'Internship',
          'mid_senior_level' => 'Mid-Level',
          'director' => 'Director',
          'executive' => 'VP'
        }
        code = data.dig('experienceLevel', 'label')
        convert[code]
      end

      def build_description(data)
        [
          ("<h2>#{data.dig('jobDescription', 'title')}</h2>" if data.dig('jobDescription', 'title')),
          data.dig('jobDescription', 'text'),
          ("<h2>#{data.dig('qualifications', 'title')}</h2>" if data.dig('qualifications', 'title')),
          data.dig('qualifications', 'text'),
          ("<h2>#{data.dig('additionalInformation', 'title')}</h2>" if data.dig('additionalInformation', 'title')),
          data.dig('additionalInformation', 'text')
        ].reject(&:blank?).join
      end
    end
  end
end
