module Ats
  module Workable
    module JobDetails
      # TODO: Check if job already exists in database
      # TODO: Update job to handle workplace (hybrid)
      # TODO: Update description to handle html and non-html, add labelling for this characteristic

      def fetch_job_data(job, ats)
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/jobs/#{job.ats_job_id}"
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def update_job_details(job, data)
        # TODO: add logic for office
        job.update(
          job_title: data['title'],
          job_description: data['description'],
          office_status: data['remote'] ? 'Remote' : 'On-site',
          location: "#{data['location']['city']}, #{data['location']['country']}",
          country: data['location']['country'],
          department: data['department'],
          requirements: data['requirements'],
          benefits: data['benefits']
        )
      end
    end
  end
end
