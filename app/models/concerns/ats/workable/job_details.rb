module Ats
  module Workable
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['title']
        location = fetch_simple_location(job_data)
        [title, location]
      end

      def fetch_id(job_data)
        apply_url = job_data['applyUrl']
        result = apply_url&.match(%r{https://apply.workable.com/j/(\w+)/apply})
        result[1] if result
      end

      private

      def job_url_api(base_url, ats_identifier, job_id)
        "#{base_url}#{ats_identifier}/jobs/#{job_id}"
      end

      def fetch_job_data(job)
        get_json_data(job.api_url, use_proxy: true)
      end

      def job_details(job, data)
        job.assign_attributes(
          title: data['title'],
          description: build_description(data),
          non_geocoded_location_string: build_location_string(data),
          posting_url: "#{url_base}#{job.company.ats_identifier}/j/#{data['shortcode']}",
          department: data['department']&.first,
          requirements: data['requirements'],
          benefits: data['benefits'],
          date_posted: (Date.parse(data['published']) if data['published']),
          remote: data['workplace'] == 'remote',
          hybrid: data['workplace'] == 'hybrid'
        )
      end

      def build_description(data)
        [
          data['description'],
          ("<h2>Requirements</h2>" if data['requirements']),
          data['requirements'],
          ("<h2>Benefits</h2>" if data['benefits']),
          data['benefits']
        ].reject(&:blank?).join
      end

      def fetch_simple_location(data)
        locations = data['locations']
        return 'United Kingdom' if locations&.any? { |location| location.include?('United Kingdom') }

        locations.first
      end

      def build_location_string(data)
        locations = data['locations']&.map do |location|
          city = location['city']
          region = location['region']
          country = location['country']
          [city, region, country].reject(&:blank?).join(', ')
        end
        locations.reject(&:blank?).join(' && ')
      end
    end
  end
end
