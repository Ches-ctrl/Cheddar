module Ats
  module Smartrecruiters
    module JobDetails

      def fetch_job_data(job, ats)
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/postings/#{job.ats_job_id}"
        p job_url_api
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def update_job_details(job, data)
        p "Updating job details - #{job.job_title}"

        # country_custom_field = data['customField'].find { |field| field['fieldId'] == "COUNTRY" }

        job.update(
          job_title: data['name'],
          job_description: data['jobAd']['sections']['jobDescription']['text'],
          office_status: data['location']['remote'] ? 'Remote' : 'Office',
          # location: "#{data['location']['city']}, #{country_custom_field['valueLabel']}",
          # country: data['customField'][1]['valueLabel'],
          seniority: data['experienceLevel']['label'],
          department: data['function']['label'],
          requirements: data['jobAd']['sections']['qualifications']['text'],
          date_created: data['releasedDate'],
          industry: data['industry']['label'],
          employment_type: data['typeOfEmployment']['label'],
          ats_job_id: data['id']
        )
      end
    end
  end
end
