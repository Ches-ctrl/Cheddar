module Ats
  module Lever
    module JobDetails
      private

      def fetch_title_and_location(job_data)
        title = job_data['text']
        job_location = build_location_string(job_data)
        [title, job_location]
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
          title: data['text'],
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

      # TODO: add logic for salary and full_time
      # def update_job_details(job, data)
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
    end
  end
end
