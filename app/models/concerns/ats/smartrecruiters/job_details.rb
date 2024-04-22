module Ats
  module Smartrecruiters
    module JobDetails
      private

      def job_url_api(base_url, ats_identifier, job_id)
        "#{base_url}#{ats_identifier}/postings/#{job_id}"
      end

      def job_details(job, data)
        job.assign_attributes(
          job_title: data['name'],
          job_description: build_description(data.dig('jobAd', 'sections')),
          job_posting_url: data['applyUrl'],
          non_geocoded_location_string: fetch_location(data),
          seniority: fetch_seniority(data),
          department: data.dig('department', 'label'),
          requirements: data.dig('jobAd', 'sections', 'qualifications', 'text'),
          date_created: (Date.parse(data['releasedDate']) if data['releasedDate']),
          industry: data.dig('industry', 'label'),
          employment_type: data.dig('typeOfEmployment', 'label'),
          remote_only: data.dig('location', 'remote')
        )
      end

      def fetch_location(data)
        country_custom_field = data['customField'].find { |field| field['fieldId'] == "COUNTRY" }

        if data.dig('location', 'remote')
          country_custom_field['valueLabel']
        else
          [data.dig('location', 'city'), country_custom_field['valueLabel']].reject(&:blank?).join(', ')
        end
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
        # TODO: This should go in description_long, and the other parts in responsibilities, benefits
        # and so on. Change this & change job show page to display description_long || description
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
