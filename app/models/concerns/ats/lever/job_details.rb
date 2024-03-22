module Ats
  module Lever
    module JobDetails
      extend ActiveSupport::Concern
      extend AtsMethods

      # TODO: Check if job already exists in database
      # TODO: Update job to handle workplace (hybrid)
      # TODO: Update description to handle html and non-html, add labelling for this characteristic

      def self.find_or_create_by_id(company, ats_job_id)
        job = Job.find_or_create_by(ats_job_id:) do |new_job|
          new_job.company = company
          data = fetch_job_data(new_job)
          return unless (new_job.job_posting_url = data['hostedUrl'])

          new_job.job_title = data['text']
          new_job.job_description = build_description(data)
          new_job.non_geocoded_location_string = build_location_string(data)
          new_job.remote_only = data['workplaceType'] == 'remote'
          new_job.department = data['categories']['team']
          # THIS NEXT LINE NOT QUITE RIGHT...
          new_job.date_created = convert_from_iso8601(data['createdAt'])
          fetch_additional_fields(new_job)
          puts "Created new job - #{new_job.job_title} with #{company.company_name}"
        end

        return job
      end

      private

      private_class_method def self.fetch_job_data(job)
        ats = this_ats
        job_url_api = "#{ats.base_url_api}#{job.company.ats_identifier}/#{job.ats_job_id}?mode=json"
        job.api_url = job_url_api
        uri = URI(job_url_api)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      private_class_method def self.build_description(data)
        data['descriptionBodyPlain'] + data['lists'].inject('') do |string, field|
                                         header = CGI.unescapeHTML(field['text'])
                                         body = CGI.unescapeHTML(field['content'])
                                         string + "\n#{header}\n#{body}"
                                       end
      end

      private_class_method def self.build_location_string(data)
        data['categories']['allLocations'].join(' & ')
      end

      private_class_method def self.update_job_details(job, data)
        # TODO: add logic for office

        timestamp = data['createdAt'] / 1000
        created_at_time = Time.at(timestamp)
        p "Job created at: #{created_at_time}"

        lines = data['descriptionPlain'].split("\n")

        salary = nil
        full_time = nil

        lines.each do |line|
          line.strip!
          if line =~ /^Salary: (.+)/i
            salary = ::Regexp.last_match(1)
          elsif line =~ /^Type: (.+)/i
            full_time = ::Regexp.last_match(1)
          end
          # Will search the remainder of the description needlessly at the moment
        end

        job.update(
          job_title: data['text'],
          job_description: data['descriptionPlain'],
          office_status: data['workplaceType'],
          location: "#{data['categories']['location']}, #{data['country']}",
          country: data['country'],
          department: data['categories']['team'],
          requirements: data['requirements'],
          benefits: data['benefits'],
          date_created: created_at_time,
          industry: job.company.industry,
          salary:,
          employment_type: full_time
        )
      end
    end
  end
end
