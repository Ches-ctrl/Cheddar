module Ats
  module Devitjobs
    module JobDetails
      private

      def fetch_title_and_location(job_data)
        title = job_data.css('title').text
        job_location = job_data.css('location').text
        [title, job_location]
      end

      def fetch_url(job_data)
        url_base + job_data['jobUrl']
      end

      def fetch_id(job_data)
        job_data['jobUrl']
      end

      def job_url_api(base_url, _company_id, _job_id)
        return base_url
      end

      def job_details(job, data)
        job.assign_attributes(
          posting_url: fetch_url(data),
          title: data['name'],
          salary: fetch_salary(data),
          remote: fetch_remote_only(data),
          non_geocoded_location_string: build_location_string(job.remote, data),
          employment_type: data['jobType'],
          seniority: fetch_seniority(data)
        )

        scrape_description_and_posting_date(job)
        # associate_technologies(job, data)
        fetch_additional_fields(job)
        puts "Created new job - #{job.title} with #{job.company.name}"
      end

      def scrape_description_and_posting_date(job)
        url = job.posting_url
        html = URI.parse(url).open
        xml = Nokogiri::HTML.parse(html)
        script_element = xml.xpath('//script[@type="application/ld+json" and @data-react-helmet="true"]').first.content
        data = JSON.parse(script_element)

        job.assign_attributes(
          description: data['description'],
          date_posted: Date.parse(data['datePosted']),
          deadline: Date.parse(data['validThrough'])
        )
      end

      def fetch_seniority(data)
        data['expLevel'] == 'Regular' ? 'Junior' : data['expLevel']
      end

      def fetch_salary(data)
        salary_low = number_with_delimiter(data['annualSalaryFrom'])
        salary_high = number_with_delimiter(data['annualSalaryTo'])
        salary_low == salary_high ? "£#{salary_low} GBP" : "£#{salary_low} - £#{salary_high} GBP"
      end

      def fetch_remote_only(data)
        data['isFullRemote'] || (data['perkKeys'].present? && data['perkKeys'].include?('remotefull'))
      end

      def build_location_string(remote, data)
        remote ? "United Kingdom" : [data['address'], data['actualCity'], data['postalCode'], 'United Kingdom'].reject(&:blank?).join(', ')
      end

      def associate_technologies(job, data)
        data['technologies'].each do |name|
          job.technologies << Technology.find_or_create_by(name:)
        end
      end
    end
  end
end
