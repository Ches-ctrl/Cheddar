module Ats
  module Devitjobs
    module JobDetails
      include ActionView::Helpers::NumberHelper
      include Capybara::DSL

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
        Capybara.current_driver = :selenium_chrome_headless
        visit url

        begin
          wait_for_javascript
          data = evaluate_script('window.__detailedJob')
        rescue Timeout::Error
          return p "Timed out waiting for JavaScript to execute for #{job.job_title}"
        ensure
          page.driver.quit
        end

        # TODO: If the javascript won't load, fetch description from page using Nokogiri & use 'activeFrom' in place of 'createdAt'

        job.job_description = fetch_job_description(data)
        job.date_created = Date.parse(data['createdAt'])
      end

      def wait_for_javascript
        Timeout.timeout(5) do
          loop until evaluate_script('typeof window.__detailedJob === "object"')
        end
      end

      def fetch_seniority(data)
        data['expLevel'] == 'Regular' ? 'Junior' : data['expLevel']
      end

      def fetch_job_description(data)
        [
          data['description'],
          data['requirementsMustTextArea'],
          data['requirementsNiceTextArea'],
          data['responsibilitiesTextArea']
        ].compact.join("\n\n")
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
