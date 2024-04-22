module Ats
  module Workable
    module JobDetails
      private

      def job_url_api(base_url, ats_identifier, job_id)
        "#{base_url}#{ats_identifier}/jobs/#{job_id}"
      end

      def job_details(job, data)
        job.assign_attributes(
          title: data['title'],
          description: build_description(data),
          # location: "#{data['location']['city']}, #{data['location']['country']}",
          # country: data['location']['country'],
          posting_url: "#{url_base}#{job.company.ats_identifier}/j/#{data['shortcode']}",
          department: data['department']&.first,
          requirements: data['requirements'],
          benefits: data['benefits'],
          date_posted: (Date.parse(data['published']) if data['published']),
          remote_only: data['workplace'] == 'remote',
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
    end
  end
end
