module Ats
  module Workable
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['title']
        location = build_location_string(job_data)
        remote_only = job_data['telecommuting']
        [title, location, remote_only]
      end

      def fetch_id(job_data)
        job_data['shortcode']
      end

      private

      def job_url_api(_base_url, ats_identifier, _job_id)
        "#{url_website}api/accounts/#{ats_identifier}?details=true"
      end

      def fetch_job_data(job)
        jobs = fetch_company_jobs(job.company.ats_identifier)
        job_data = jobs.find { |data| data['shortcode'] == job.ats_job_id }
        return mark_job_expired(job) unless job_data
      end

      def job_details(job, data)
        title, non_geocoded_location_string, remote = fetch_title_and_location(data)
        job.assign_attributes(
          title:,
          description: Flipper.enabled?(:job_description) ? data['description'] : 'Not added yet',
          non_geocoded_location_string:,
          posting_url: data['url'],
          apply_url: data['application_url'],
          department: data['department'],
          seniority: data['experience'], # TODO: standardize this
          industry: data['industry'],
          date_posted: (Date.parse(data['published_on']) if data['published_on']),
          remote:,
          employment_type: data['employment_type']
        )
      end

      # def build_description(data)
      #   [
      #     data['description'],
      #     ("<h2>Requirements</h2>" if data['requirements']),
      #     data['requirements'],
      #     ("<h2>Benefits</h2>" if data['benefits']),
      #     data['benefits']
      #   ].reject(&:blank?).join
      # end

      def build_location_string(data)
        locations = data['locations']&.map do |location|
          city = location['city']
          region = location['region']
          country = location['country']
          [city, region, country].reject(&:blank?).join(', ')
        end
        locations&.reject(&:blank?)&.join(' && ')
      end
    end
  end
end
