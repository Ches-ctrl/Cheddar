module Ats
  module Workday
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['title']
        location = fetch_location(job_data)
        [title, location]
      end

      def fetch_id(job_data)
        return unless job_data.is_a?(Hash)

        path = job_data['externalPath']
        path.split('/').last(2).join('/')
      end

      def fetch_detailed_job_data(ats_identifier, job_id)
        return unless ats_identifier && job_id

        endpoint = job_url_api(url_api, ats_identifier, job_id)
        get_json_data(endpoint)
      end

      def job_url_api(_base_url, ats_identifier, job_id)
        base = fetch_base_url(ats_identifier)
        "#{base}job/#{job_id}"
      end

      def job_details(_job, data)
        job_data = data['jobPostingInfo']
        title, location = fetch_title_and_location(job_data)
        {
          title:,
          description: Flipper.enabled?(:job_description) ? job_data['jobDescription'] : 'Not added yet',
          posting_url: job_data['externalUrl'],
          remote: remote?(location),
          non_geocoded_location_string: location,
          date_posted: job_data['startDate'].to_date,
          industry: job_data.dig('industry', 'label'), # not sure if this works
          employment_type: job_data['timeType']
        }
      end

      private

      def fetch_location(data)
        location = data['locationsText']
        return fetch_quick_location(location) if location # this is not detailed data

        location = data['location']
        more_locations = data['additionalLocations']
        location = fetch_multiple_locations(location, more_locations) if more_locations

        country_string = data.dig('country', 'descriptor')
        if remote?(location)
          country_string
        else
          location
        end
      end

      def fetch_quick_location(location)
        # if short version of job_data indicates multiple locations, punt on figuring out location until the job is created
        multiloc_keywords = %w[locations more]
        loc_is_multiple = multiloc_keywords.any? { |keyword| location.downcase.include?(keyword) }
        loc_is_multiple ? 'London' : location # London means job won't be excluded b/c !relevant?
      end

      def fetch_multiple_locations(location, more_locations)
        loc_array = [location] + more_locations
        loc_array.join(' && ')
      end

      def remote?(location)
        locations = location.split(' && ')
        locations.all? { |string| string.match?(/remote|offsite/i) }
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
