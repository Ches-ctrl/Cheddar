module Ats
  module Workable
    module JobDetails
      def fetch_job_data(job)
        response = get(job.api_url)
        JSON.parse(response)
      end

      def job_url_api(base_url, ats_identifier, job_id)
        "#{base_url}#{ats_identifier}/jobs/#{job_id}"
      end

      def job_details(job, data)
        job.assign_attributes(
          job_title: data['title'],
          job_description: build_description(data),
          # location: "#{data['location']['city']}, #{data['location']['country']}",
          # country: data['location']['country'],
          job_posting_url: "#{base_url_main}#{job.company.ats_identifier}/j/#{data['shortcode']}",
          department: data['department']&.first,
          requirements: data['requirements'],
          benefits: data['benefits'],
          date_created: (Date.parse(data['published']) if data['published']),
          remote_only: data['workplace'] == 'remote',
          hybrid: data['workplace'] == 'hybrid'
        )
      end

      def build_description(data)
        # TODO: This should go in description_long, and the other parts in responsibilities, benefits
        # and so on. Change this & change job show page to display description_long || description
        [
          data['description'],
          ("<h2>Requirements</h2>" if data['requirements']),
          data['requirements'],
          ("<h2>Benefits</h2>" if data['benefits']),
          data['benefits']
        ].reject(&:blank?).join
      end
    end
  end
end
