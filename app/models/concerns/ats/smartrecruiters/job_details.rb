module Ats
  module Smartrecruiters
    module JobDetails
      # TODO: Check if job already exists in database
      # TODO: Update job to handle workplace (hybrid)
      # TODO: Update description to handle html and non-html, add labelling for this characteristic
      # TODO: Change default application deadline

      def self.find_or_create_by_id(_company, _ats_job_id)
        return
      end

      def self.get_job_details(job)
        ats = job.company.applicant_tracking_system
        data = fetch_job_data(job, ats)
        update_job_details(job, data)
        p "Updated job details - #{job.job_title}"
        job
      end

      def self.fetch_job_data(job, ats)
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/postings/#{job.ats_job_id}"
        p job_url_api
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def self.update_job_details(job, data)
        # TODO: add logic for office
        # TODO: handle additional information

        p "Updating job details - #{job.job_title}"

        country_custom_field = data['customField'].find { |field| field['fieldId'] == "COUNTRY" }

        job.update(
          job_title: data['name'],
          job_description: data['jobAd']['sections']['jobDescription']['text'],
          office_status: data['location']['remote'] ? 'Remote' : 'Office',
          location: "#{data['location']['city']}, #{country_custom_field['valueLabel']}",
          country: data['customField'][1]['valueLabel'],
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
