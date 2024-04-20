module Ats
  module Lever
    module JobDetails
      # TODO: Check if job already exists in database
      # TODO: Update job to handle workplace (hybrid)
      # TODO: Update description to handle html and non-html, add labelling for this characteristic

      private

      def fetch_title_and_location(job_data)
        job_title = job_data['text']
        job_location = build_location_string(job_data)
        [job_title, job_location]
      end

      def fetch_url(job_data)
        job_data['hostedUrl']
      end

      def fetch_id(job_data)
        job_data['id']
      end

      def job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/#{job_id}?mode=json"
      end

      def job_details(job, data)
        # TODO: add logic for office
        job.assign_attributes(
          job_posting_url: data['hostedUrl'],
          job_title: data['text'],
          job_description: build_description(data),
          non_geocoded_location_string: build_location_string(data),
          remote_only: data['workplaceType'] == 'remote',
          department: data.dig('categories', 'team'),
          date_created: convert_from_milliseconds(data['createdAt'])
        )
        fetch_additional_fields(job)
      end

      def build_description(data)
        data['descriptionBodyPlain'] + data['lists'].inject('') do |string, field|
                                         string + field['text'] + field['content']
                                       end
      end

      def build_location_string(data)
        data.dig('categories', 'allLocations').join(' && ')
      end

      # def update_job_details(job, data)
      #   # TODO: add logic for office

      #   timestamp = data['createdAt'] / 1000
      #   created_at_time = Time.at(timestamp)
      #   p "Job created at: #{created_at_time}"

      #   lines = data['descriptionPlain'].split("\n")

      #   salary = nil
      #   full_time = nil

      #   lines.each do |line|
      #     line.strip!
      #     if line =~ /^Salary: (.+)/i
      #       salary = ::Regexp.last_match(1)
      #     elsif line =~ /^Type: (.+)/i
      #       full_time = ::Regexp.last_match(1)
      #     end
      #     # Will search the remainder of the description needlessly at the moment
      #   end

      #   job.update(
      #     job_title: data['text'],
      #     job_description: data['descriptionPlain'],
      #     office_status: data['workplaceType'],
      #     # location: "#{data['categories']['location']}, #{data['country']}",
      #     country: data['country'],
      #     department: data['categories']['team'],
      #     requirements: data['requirements'],
      #     benefits: data['benefits'],
      #     date_created: created_at_time,
      #     industry: job.company.industry,
      #     salary:,
      #     employment_type: full_time
      #   )
      # end
    end
  end
end
