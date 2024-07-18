module Ats
  module Trueup
    module JobDetails
      include ActionView::Helpers::NumberHelper

      def fetch_id(job_data)
        p "Fetching ID"
        job_data['unique_id']
      end

      def job_url_api(base_url, _company_id, _job_id)
        p "Fetching job URL"
        return base_url
      end

      def job_details(_job, data)
        p "Fetching job details"
        {
          title: data['title'],
          description: build_description(data),
          posting_url: data['url'],
          date_posted: (Date.parse(data['updated_at']) if data['updated_at']),
          salary: build_salary(data),
          non_geocoded_location_string: data['location']
        }
        # associate_technologies(job, data)
      end

      private

      def build_description(data)
        title = data['title']
        company_name = data['company_short']
        business_description = data['business_description_short']
        location = data['location']
        apply_url = data['url']
        "<p>#{company_name}, a #{business_description&.downcase} company, is hiring a #{title} in #{location}.</p><p>To apply, visit <a href=\"#{apply_url}\">#{apply_url}</a>.</p>"
      end

      def build_salary(data)
        currency = 'GBP' # assumes that the salary is listed in GBP
        symbol = '£'

        min = data['salary_range_min']
        max = data['salary_range_max']
        return unless min

        salary_low = "#{symbol}#{number_with_delimiter(min)} "
        salary_high = max.present? ? "- #{symbol}#{number_with_delimiter(max)} " : ''
        "#{salary_low}#{salary_high} #{currency}}"
      end
    end
  end
end
