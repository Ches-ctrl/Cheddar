module Ats
  module Devitjobs
    module JobDetails
      include ActionView::Helpers::NumberHelper

      def fetch_title_and_location(job_data)
        p "Fetching title and location"
        title = job_data['name']
        remote = fetch_remote_only(job_data)
        job_location = build_location_string(remote, job_data)
        [title, job_location, remote]
      end

      def fetch_url(job_data)
        p "Fetching URL"
        url_base + job_data['jobUrl']
      end

      def job_url_api(base_url, _company_id, _job_id)
        p "Fetching job URL"
        return base_url
      end

      def job_details(_job, data)
        p "Fetching job details"
        title, location, remote = fetch_title_and_location(data)
        posting_url = fetch_url(data)
        description, date_posted, deadline = scrape_description_and_posting_date(posting_url)
        {
          title:,
          description:,
          posting_url:,
          date_posted:,
          deadline:,
          salary: fetch_salary(data),
          remote:,
          non_geocoded_location_string: location,
          employment_type: data['jobType'],
          seniority: fetch_seniority(data)
        }
        # associate_technologies(job, data)
      end

      def fetch_id(job_data)
        p "Fetching ID"
        job_data['jobUrl']
      end

      private

      def scrape_description_and_posting_date(posting_url)
        p "Scraping description and posting date"
        html = URI.parse(posting_url).open
        xml = Nokogiri::HTML.parse(html)
        script_element = xml.xpath('//script[@type="application/ld+json" and @data-react-helmet="true"]').first.content
        data = JSON.parse(script_element)

        [
          description: Flipper.enabled?(:job_description) ? data['description'] : 'Not added yet',
          date_posted: Date.parse(data['datePosted']),
          deadline: Date.parse(data['validThrough'])
        ]
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
