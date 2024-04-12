module Ats
  module Devitjobs
    module JobDetails
      include ActionView::Helpers::NumberHelper

      def fetch_title_and_location(job_data)
        job_title = job_data.css('title').text
        job_location = job_data.css('location').text
        [job_title, job_location]
      end

      def fetch_url(job_data)
        base_url_main + job_data['jobUrl']
      end

      private

      def fetch_id(job_data)
        job_data['jobUrl']
      end

      def job_url_api(base_url, _company_id, _job_id)
        return base_url
      end

      def update_job_details(job, data)
        job.job_posting_url = fetch_url(data)
        job.job_title = data['name']
        job.salary = fetch_salary(data)
        job.remote_only = fetch_remote_only(data)
        job.non_geocoded_location_string = fetch_location_string(job.remote_only, data)
        job.employment_type = data['jobType']
        job.seniority = fetch_seniority(data)

        scrape_description_and_posting_date(job)

        # associate_technologies(job, data)

        fetch_additional_fields(job)
        puts "Created new job - #{job.job_title} with #{job.company.company_name}"
      end

      def scrape_description_and_posting_date(job)
        url = job.job_posting_url
        html = URI.parse(url).open
        xml = Nokogiri::HTML.parse(html)
        script_element = xml.xpath('//script[@type="application/ld+json" and @data-react-helmet="true"]').first.content
        data = JSON.parse(script_element)

        job.job_description = data['description']
        job.date_created = Date.parse(data['datePosted'])
        # job.expiry_date = Date.parse(data['validThrough'])
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

      def fetch_location_string(remote_only, data)
        remote_only ? "United Kingdom" : [data['address'], data['actualCity'], data['postalCode'], 'United Kingdom'].reject(&:blank?).join(', ')
      end

      def associate_technologies(job, data)
        data['technologies'].each do |name|
          job.technologies << Technology.find_or_create_by(name:)
        end
      end
    end
  end
end
