module Ats
  module Lever
    module JobDetails
      extend AtsMethods
      extend JobDetailsMethods

      # TODO: Check if job already exists in database
      # TODO: Update job to handle workplace (hybrid)
      # TODO: Update description to handle html and non-html, add labelling for this characteristic

      def self.fetch_title_and_location(job_data)
        job_title = job_data['text']
        job_location = build_location_string(job_data)
        [job_title, job_location]
      end

      def self.fetch_url(job_data)
        job_data['hostedUrl']
      end

      private

      private_class_method def self.fetch_id(job_data)
        job_data['id']
      end

      private_class_method def self.job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/#{job_id}?mode=json"
      end

      private_class_method def self.build_description(data)
        data['descriptionBodyPlain'] + data['lists'].inject('') do |string, field|
                                         header = CGI.unescapeHTML(field['text'])
                                         body = CGI.unescapeHTML(field['content'])
                                         string + "\n#{header}\n#{body}"
                                       end
      end

      private_class_method def self.build_location_string(data)
        data.dig('categories', 'allLocations').join(' & ')
      end

      private_class_method def self.update_job_details(job, data)
        job.job_posting_url = data['hostedUrl']
        job.job_title = data['text']
        job.job_description = build_description(data)
        job.non_geocoded_location_string = build_location_string(data)
        job.remote_only = data['workplaceType'] == 'remote'
        job.department = data.dig('categories', 'team')
        job.date_created = convert_from_milliseconds(data['createdAt'])
        fetch_additional_fields(job)
        puts "Created new job - #{job.job_title} with #{job.company.company_name}"
      end
      # private_class_method def self.update_job_details(job, data)
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
