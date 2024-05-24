module Ats
  module Lever
    module JobDetails
      def fetch_title_and_location(job_data)
        title = job_data['text']
        job_location = build_location_string(job_data)
        [title, job_location]
      end

      def fetch_id(job_data)
        job_data['id']
      end

      def fetch_url(job_data)
        job_data['hostedUrl']
      end

      private

      def job_url_api(base_url, company_id, job_id)
        "#{base_url}#{company_id}/#{job_id}?customQuestions=true"
      end

      def job_details(job, data)
        title, location = fetch_title_and_location(data)
        job.assign_attributes(
          posting_url: data['hostedUrl'],
          title:,
          description: Flipper.enabled?(:job_description) ? build_description(data) : 'Not added yet',
          non_geocoded_location_string: location,
          remote: data['workplaceType'] == 'remote',
          department: data.dig('categories', 'team'),
          date_posted: convert_from_milliseconds(data['createdAt'])
        )
      end

      def build_description(data)
        data['descriptionBody'] + data['lists'].inject('') do |string, field|
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
